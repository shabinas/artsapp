import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'google_home.dart';
import 'organizer_home.dart'; // Ensure you import your HomePage here

class OgLoginPage extends StatefulWidget {
  @override
  _OgLoginPageState createState() => _OgLoginPageState();
}

class _OgLoginPageState extends State<OgLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _email = '';
  String _password = '';
  String _verificationId = '';

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _login() async {
  
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Access the user's UID
        String uid = userCredential.user!.uid;

        // Navigate to the HomePage upon successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(organizerId: uid)),
        );
      } on FirebaseAuthException catch (e) {
        // Handle login errors
        print('Error: $e');
        String errorMessage = '';

        // Determine the error message based on the error code
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Invalid email address';
            break;
          case 'user-not-found':
            errorMessage = 'No user found with this email';
            break;
          case 'wrong-password':
            errorMessage = 'Invalid password';
            break;
          case 'user-disabled':
            errorMessage = 'User account has been disabled';
            break;
          default:
            errorMessage = 'Login failed. $e Please try again.';
            break;
        }

        // Show a snackbar to indicate login failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userId = userCredential.user!.uid;
        prefs.setString('userId', userId);

        // Check if the user already exists in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('organizers').doc(userId).get();

        if (!userDoc.exists) {
          // Add user to Firestore if not exists
          String name = userCredential.user!.displayName ?? "";
          String email = userCredential.user!.email ?? "";
          String imageUrl = userCredential.user!.photoURL ?? "";

          await FirebaseFirestore.instance.collection('organizers').doc(userId).set({
            'name': name,
            'email': email,
            'imageUrl': imageUrl,
            'phone': "null",
            'idNumber': "null",
            'status': "Pending",
          });
        }

        // Navigate to the HomePage upon successful Google sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(organizerId: userId),
          ),
        );
      }
    } catch (error) {
      print("Google sign-in error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed. Please try again.')),
      );
    }
  }

  Future<void> _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        _navigateToHomePage();
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Failed to verify phone number: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify phone number. Try again.')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });

        // Display the SMS Code input UI
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification code sent. Check your SMS.')),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text.trim(),
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _navigateToHomePage();
      }
    } catch (e) {
      print("Failed to sign in with phone number: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with phone number. Try again.')),
      );
    }
  }

  Future<void> _navigateToHomePage() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', userId);

      // Check if the user already exists in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('organizers').doc(userId).get();

      if (!userDoc.exists) {
        String name = user.displayName ?? "";
        String email = user.email ?? "";
        String phone = user.phoneNumber ?? "";

        await FirebaseFirestore.instance.collection('organizers').doc(userId).set({
          'name': name,
          'email': email,
          'phone': phone,
          'idNumber': "null",
          'status': "Pending",
        });
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(organizerId: userId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Add email validation if needed
                    return null;
                  },
                  onChanged: (value) => _email = value.trim(),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    // Add password strength validation if needed
                    return null;
                  },
                  onChanged: (value) => _password = value.trim(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signInWithGoogle,
                  child: Text('Login with Google'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _verifyPhoneNumber,
                  child: Text('Verify Phone Number'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _smsController,
                  decoration: InputDecoration(labelText: 'SMS Code'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signInWithPhoneNumber,
                  child: Text('Login with Phone Number'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}