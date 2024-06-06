import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Organizer_detail extends StatefulWidget {
  final String? name;
  final String? idNumber;
  final String? phone;
  final String? iddata;

  Organizer_detail({Key? key, this.name, this.idNumber, this.phone, this.iddata}) : super(key: key);

  @override
  State<Organizer_detail> createState() => _Organizer_detailState();
}

class _Organizer_detailState extends State<Organizer_detail> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Add GlobalKey
  String _status = ''; // Store the acceptance or rejection status

  void _acceptOrganizer() {
    if (widget.iddata == null) {
      _showErrorSnackBar('Invalid organizer ID');
      return;
    }

    // Update organizer status to accepted in Firestore
    _firestore.collection('organizers').doc(widget.iddata).update({
      'status': 'Accepted',
    }).then((_) {
      // Handle success
      print('Organizer accepted');
      setState(() {
        _status = 'Accepted'; // Update the status
      });
    }).catchError((error) {
      // Handle error
      print('Failed to accept organizer: $error');
      _showErrorSnackBar('Failed to accept organizer: $error'); // Show error message
    });
  }

  void _rejectOrganizer() {
    if (widget.iddata == null) {
      _showErrorSnackBar('Invalid organizer ID');
      return;
    }

    // Update organizer status to rejected in Firestore
    _firestore.collection('organizers').doc(widget.iddata).update({
      'status': 'Rejected',
    }).then((_) {
      // Handle success
      print('Organizer rejected');
      setState(() {
        _status = 'Rejected'; // Update the status
      });
    }).catchError((error) {
      // Handle error
      print('Failed to reject organizer: $error');
      _showErrorSnackBar('Failed to reject organizer: $error'); // Show error message
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
      key: _scaffoldKey, // Assign the GlobalKey to Scaffold
      appBar: AppBar(
        title: Text('Organizer Detail'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage("https://www.mockofun.com/wp-content/uploads/2019/12/circle-photo.jpg"),
                  radius: 50, // Adjust the size of the circle avatar
                ),
                SizedBox(height: 20), // Add spacing between widgets
                Text(
                  "Name: ${widget.name ?? 'N/A'}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10), // Add spacing between widgets
                Text(
                  "ID Number: ${widget.idNumber ?? 'N/A'}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10), // Add spacing between widgets
                Text(
                  "Phone Number: ${widget.phone ?? 'N/A'}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 60), // Add spacing between widgets
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3, // Set width to 40% of screen width
                      child: ElevatedButton(
                        onPressed: _acceptOrganizer,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Set border radius
                          ),
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 16.0), // Set vertical padding
                        ),
                        child: Text('Accept', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3, // Set width to 40% of screen width
                      child: ElevatedButton(
                        onPressed: _rejectOrganizer,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Set border radius
                          ),
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 16.0), // Set vertical padding
                        ),
                        child: Text('Reject', style: TextStyle(color: Colors.white)),
                      ),
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