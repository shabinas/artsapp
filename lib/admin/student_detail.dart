import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Student_detail extends StatefulWidget {
  final String name;
  final String idNumber;
  final String department;
  final String phone;
  final String idData;

  Student_detail({
    Key? key,
    required this.name,
    required this.idNumber,
    required this.department,
    required this.phone,
    required this.idData,
  }) : super(key: key);

  @override
  State<Student_detail> createState() => _Student_detailState();
}

class _Student_detailState extends State<Student_detail> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Add GlobalKey
  String _status = ''; // Store the acceptance or rejection status

  void _acceptStudent() {
    // Update student status to accepted in Firestore
    _firestore.collection('students').doc(widget.idData).update({
      'status': 'Accepted',
    }).then((_) {
      // Handle success
      print('Student accepted');
      setState(() {
        _status = 'Accepted'; // Update the status
      });
    }).catchError((error) {
      // Handle error
      print('Failed to accept student: $error');
      _showErrorSnackBar('Failed to accept student: $error'); // Show error message
    });
  }

  void _rejectStudent() {
    // Update student status to rejected in Firestore
    _firestore.collection('students').doc(widget.idData).update({
      'status': 'Rejected',
    }).then((_) {
      // Handle success
      print('Student rejected');
      setState(() {
        _status = 'Rejected'; // Update the status
      });
    }).catchError((error) {
      // Handle error
      print('Failed to reject student: $error');
      _showErrorSnackBar('Failed to reject student: $error'); // Show error message
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign scaffold key
      appBar: AppBar(
        title: Text('Student Detail'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://www.mockofun.com/wp-content/uploads/2019/12/circle-photo.jpg"),
                  radius: 50, // Adjust the size of the circle avatar
                ),
                SizedBox(height: 20), // Add spacing between widgets
                Text(
                  "Name: ${widget.name}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10), // Add spacing between widgets
                Text(
                  "ID Number: ${widget.idNumber}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10), // Add spacing between widgets
                Text(
                  "Department: ${widget.department}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10), // Add spacing between widgets
                Text(
                  "Phone Number: ${widget.phone}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 30), // Add spacing between widgets
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _acceptStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Accept'),
                    ),
                    ElevatedButton(
                      onPressed: _rejectStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Reject'),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Add spacing between widgets
                Text(
                  'Status: $_status', // Display the status
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _status == 'Accepted' ? Colors.green : _status == 'Rejected' ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
