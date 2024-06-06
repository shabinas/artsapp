import 'package:finearts/student/StudentApplyPage.dart';
import 'package:flutter/material.dart';

class StudentEventDetailPage extends StatelessWidget {
  final Map<String, dynamic> event;

  StudentEventDetailPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.person, size: 50, color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                event['eventName'].toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Date',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
              event['date'].toString(),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Stage No',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
              event['stageNo'].toString(),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Time',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
              event['time'].toString(),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Location',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
              event['location'].toString(),
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplyPage(event: event),
                    ),
                  );
                },
                child: Text('Apply'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
