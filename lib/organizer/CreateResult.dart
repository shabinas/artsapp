import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddResultPage extends StatefulWidget {
  final String organizerId;

  const AddResultPage({Key? key, required this.organizerId}) : super(key: key);

  @override
  _AddResultPageState createState() => _AddResultPageState();
}

class _AddResultPageState extends State<AddResultPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _selectedEventId;
  List<Map<String, dynamic>> _assignedEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchAssignedEvents();
  }

  Future<void> _fetchAssignedEvents() async {
    try {
      DocumentSnapshot organizerDoc = await FirebaseFirestore.instance
          .collection('organizers')
          .doc(widget.organizerId)
          .get();

      List<String> assignedEventIds = List<String>.from(organizerDoc['assignedEvents'] ?? []);

      for (String eventId in assignedEventIds) {
        DocumentSnapshot eventDoc = await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .get();
        if (eventDoc.exists) {
          setState(() {
            _assignedEvents.add({
              ...eventDoc.data() as Map<String, dynamic>,
              'id': eventDoc.id
            });
          });
        }
      }
    } catch (e) {
      print('Error fetching assigned events: $e');
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
    if (_imageFile != null && _selectedEventId != null) {
      try {
        String fileName = '${_selectedEventId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('result_images/$fileName')
            .putFile(_imageFile!);

        String downloadUrl = await snapshot.ref.getDownloadURL();
        // Save the URL and other information to Firestore or use as needed
        print('Uploaded Image URL: $downloadUrl');

        // Optionally: Save the URL in Firestore under the selected event
        await FirebaseFirestore.instance
            .collection('events')
            .doc(_selectedEventId)
            .update({'resultImageUrl': downloadUrl});

        // Add success message or navigation here
      } catch (e) {
        print('Error uploading image: $e');

        // Show error message dialog
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
        title: Text('Add Result'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedEventId,
              onChanged: (value) {
                setState(() {
                  _selectedEventId = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Event',
                border: OutlineInputBorder(),
              ),
              items: _assignedEvents.map((event) {
                return DropdownMenuItem<String>(
                  value: event['id'],
                  child: Text(event['eventName']),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Image', style: TextStyle(fontSize: 16)),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : Center(child: Icon(Icons.image, size: 100)),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                //primary: Colors.blueGrey, // button color
                //onPrimary: Colors.white, // text color
                fixedSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}