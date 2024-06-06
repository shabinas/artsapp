import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplyPage extends StatefulWidget {
  final Map<String, dynamic> event;

  ApplyPage({required this.event});

  @override
  _ApplyPageState createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> userInfo = {};
  bool isLoading = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

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
        userInfo = userDoc.data() as Map<String, dynamic>;

        // Initialize controllers with user info
        nameController.text = userInfo['name'] ?? '';
        idNumberController.text = userInfo['idNumber'] ?? '';
        phoneController.text = userInfo['phone'] ?? '';
        departmentController.text = userInfo['department'] ?? '';

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Update student information if changed
          await FirebaseFirestore.instance.collection('students').doc(user.uid).update({
            'name': nameController.text,
            'idNumber': idNumberController.text,
            'phone': phoneController.text,
            'department': departmentController.text,
            'selectedEvents': FieldValue.arrayUnion([widget.event['id']])
          });

          // Add student to the event's participants
          await FirebaseFirestore.instance.collection('events').doc(widget.event['id']).update({
            'participants': FieldValue.arrayUnion([user.uid])
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Application submitted successfully')));
        }
      } catch (e) {
        print('Error submitting application: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting application')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply'),
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
                        child: Icon(Icons.person, size: 50, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField('Name', nameController),
                    SizedBox(height: 20),
                    _buildTextField('ID Number', idNumberController),
                    SizedBox(height: 20),
                    _buildTextField('Phone No', phoneController),
                    SizedBox(height: 20),
                    _buildTextField('Department', departmentController),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitApplication,
                      child: Text('Submit'),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
