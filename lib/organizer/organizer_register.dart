import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Organizer_registration extends StatefulWidget {
  @override
  _Organizer_registrationState createState() => _Organizer_registrationState();
}

class _Organizer_registrationState extends State<Organizer_registration> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _idNumber = '';
  String _department = '';
  String _phoneNumber = '';

  void _register() async {
  if (_formKey.currentState!.validate()) {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      await _firestore.collection('organizers').doc(userCredential.user!.uid).set({
        'name': _name,
        'phone': _phoneNumber,
        'email': _email,
        'idNumber': _idNumber,
        'assignedEvents':null,
      });

      // Navigate to the next screen or perform any other action upon successful registration

      // Show a snackbar to indicate successful registration
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Show a snackbar to indicate that the email is already in use
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The email entered is already in use')),
        );
      } else {
        print('Error: $e');
        // Handle other FirebaseAuth exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Handle registration errors

      // Show a snackbar to indicate registration failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed. Please try again.')),
      );
    }
  }
}

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // You can add more specific phone number validation rules if needed
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Registration')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Name',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onChanged: (value) => _name = value,
                ),
                SizedBox(height: 10),
                Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePhoneNumber,
                  onChanged: (value) => _phoneNumber = value,
                ),
                SizedBox(height: 10),
                Text(
                  'Email',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Add email validation here
                    return null;
                  },
                  onChanged: (value) => _email = value,
                ),
                SizedBox(height: 10),
                Text(
                  'Password',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    // Add password strength validation here
                    return null;
                  },
                  onChanged: (value) => _password = value,
                ),
                SizedBox(height: 10),
                Text(
                  'Confirm Password',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _password) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  onChanged: (value) => _confirmPassword = value,
                ),
                SizedBox(height: 10),
                Text(
                  'ID Number',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ID number';
                    }
                    // Add specific ID number validation here
                    return null;
                  },
                  onChanged: (value) => _idNumber = value,
                ),
                
                
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
