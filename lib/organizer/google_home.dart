import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleHome extends StatefulWidget {
  const GoogleHome({Key? key}) : super(key: key);

  @override
  _GoogleHomeState createState() => _GoogleHomeState();
}

class _GoogleHomeState extends State<GoogleHome> {
  User? _user;
  String? _name;
  String? _email;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Guser').doc(userId).get();
      setState(() {
        _name = userDoc['name'];
        _email = userDoc['email'];
        _imageUrl = userDoc['imageUrl'];
      });
    }
  }

  Future<void> _signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(_imageUrl!),
                    radius: 50,
                  )
                : CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
            SizedBox(height: 20),
            Text(
              _name ?? 'Guest',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(_email ?? ''),
          ],
        ),
      ),
    );
  }
}