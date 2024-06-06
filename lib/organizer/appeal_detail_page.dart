import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppealDetailPage extends StatelessWidget {
  final Map<String, dynamic> appeal;
  final String eventId;

  AppealDetailPage({required this.appeal, required this.eventId});

  Future<void> _updateStatus(String status, BuildContext context) async {
    try {
      // Update the appeal document in the appeals collection
      await FirebaseFirestore.instance
          .collection('appeals')
          .doc(appeal['appealId'])
          .update({'status': status});

      // Update the lastAppeal status in the student's document
      await FirebaseFirestore.instance
          .collection('students')
          .doc(appeal['userId'])
          .update({
        'lastAppeal.status': status,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appeal status updated to $status')));
      Navigator.pop(context, true); // Return true to indicate that the status was updated
    } catch (e) {
      print('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating status: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appeal Detail'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event Name', style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            TextFormField(
              initialValue: appeal['eventName'] ?? 'N/A',
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
              initialValue: appeal['videoLink'] ?? 'N/A',
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
              initialValue: appeal['description'] ?? 'N/A',
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
            Text('Status', style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            TextFormField(
              initialValue: appeal['status'] ?? 'Pending',
              readOnly: true,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              ),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _updateStatus('Accepted', context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Accept', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _updateStatus('Rejected', context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('Reject', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}