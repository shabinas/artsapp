import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateResult extends StatefulWidget {
  final String organizerId;
  final String eventId;
  final String eventName;
  final String videoLink;
  final String description;

  const UpdateResult({
    Key? key,
    required this.organizerId,
    required this.eventId,
    required this.eventName,
    required this.videoLink,
    required this.description,
  }) : super(key: key);

  @override
  _UpdateResultState createState() => _UpdateResultState();
}

class _UpdateResultState extends State<UpdateResult> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchExistingImageUrl();
  }

  Future<void> _fetchExistingImageUrl() async {
    try {
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .get();

      if (eventDoc.exists && eventDoc.data() != null) {
        setState(() {
          _existingImageUrl = eventDoc['resultImageUrl'];
        });
      }
    } catch (e) {
      print('Error fetching existing image URL: $e');
    }
  }

  Future<void> _deleteExistingImage() async {
    if (_existingImageUrl != null) {
      try {
        Reference storageRef = FirebaseStorage.instance.refFromURL(_existingImageUrl!);
        await storageRef.delete();
        print('Existing image deleted successfully');
      } catch (e) {
        print('Error deleting existing image: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        // Delete the existing image if it exists
        await _deleteExistingImage();

        // Upload the new image
        String fileName = '${widget.eventId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('result_images/$fileName')
            .putFile(_imageFile!);

        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Save the new image URL to Firestore
        await FirebaseFirestore.instance
            .collection('events')
            .doc(widget.eventId)
            .update({'resultImageUrl': downloadUrl});

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded successfully')));
        Navigator.pop(context);
      } catch (e) {
        print('Error uploading image: $e');
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to upload image: ${e.toString()}'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show message if no image is selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Image Selected'),
            content: Text('Please select an image before submitting.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Result'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Event Name', style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              TextFormField(
                initialValue: widget.eventName,
                readOnly: true,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                ),
              ),
              SizedBox(height: 20),
              Text('Video Link', style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              TextFormField(
                initialValue: widget.videoLink,
                readOnly: true,
                style: TextStyle(fontSize: 18, color: Colors.blue),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                ),
              ),
              SizedBox(height: 20),
              Text('Description', style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              TextFormField(
                initialValue: widget.description,
                readOnly: true,
                maxLines: 6,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                ),
              ),
              SizedBox(height: 20),
              Text('Result', style: TextStyle(fontSize: 16)),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : Center(child: Icon(Icons.image, size: 100)),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}