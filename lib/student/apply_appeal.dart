import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApplyAppealPage extends StatefulWidget {
  final Map<String, dynamic> event;

  ApplyAppealPage({required this.event});

  @override
  _ApplyAppealPageState createState() => _ApplyAppealPageState();
}

class _ApplyAppealPageState extends State<ApplyAppealPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> userInfo = {};
  bool isLoading = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController videoLinkController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('students').doc(user.uid).get();
        if (userDoc.exists) {
          userInfo = userDoc.data() as Map<String, dynamic>;

          // Initialize controllers with user info
          nameController.text = userInfo['name'] ?? '';
          departmentController.text = userInfo['department'] ?? '';

          setState(() {
            isLoading = false;
          });
        } else {
          print('User document does not exist');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User info not found')));
        }
      } else {
        print('No user logged in');
      }
    } catch (e) {
      print('Error fetching user info: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching user info')));
    }
  }

  Future<void> _submitAppeal() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Prepare appeal data
          Map<String, dynamic> appealData = {
            'userId': user.uid,
            'eventId': widget.event['id'],
            'videoLink': videoLinkController.text,
            'description': descriptionController.text,
            'status': 'Pending', // Include the appeal status
            'timestamp': FieldValue.serverTimestamp(),
          };

          // Create a new appeal document in the appeals collection
          DocumentReference appealDoc = await FirebaseFirestore.instance.collection('appeals').add(appealData);

          // Update student's document with the latest appeal information
          await FirebaseFirestore.instance.collection('students').doc(user.uid).update({
            'lastAppeal': {
              'appealId': appealDoc.id,
              'eventId': widget.event['id'],
              'videoLink': videoLinkController.text,
              'description': descriptionController.text,
              'status': 'Pending', // Include the appeal status
            },
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appeal submitted successfully')));
          Navigator.pop(context); // Go back to the previous screen
        }
      } catch (e) {
        print('Error submitting appeal: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting appeal: ${e.toString()}')));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    videoLinkController.dispose();
    departmentController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Event data: ${widget.event}'); // Debugging print

    return Scaffold(
      appBar: AppBar(
        title: Text('Apply Appeal'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.person, size: 40, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField('Name', nameController, readOnly: true),
                    SizedBox(height: 20),
                    _buildTextField('Video Link', videoLinkController),
                    SizedBox(height: 20),
                    _buildTextField('Department', departmentController, readOnly: true),
                    SizedBox(height: 20),
                    _buildTextField('Description', descriptionController, maxLines: 4),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isLoading ? null : _submitAppeal,
                      child: Text('Apply'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}