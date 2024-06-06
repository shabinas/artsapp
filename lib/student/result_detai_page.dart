import 'package:finearts/student/apply_appeal.dart';
import 'package:flutter/material.dart';

class StResultDetailPage extends StatelessWidget {
 final Map<String, dynamic> event;

  const StResultDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  event['eventName'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Date: ${event['date']}', style: TextStyle(fontSize: 18)),
              Text('Stage No: ${event['stage']}', style: TextStyle(fontSize: 18)),
              Text('Time: ${event['time']}', style: TextStyle(fontSize: 18)),
              Text('Location: ${event['location']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text('Result', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: event['resultImageUrl'] != null && event['resultImageUrl'].isNotEmpty
                    ? Image.network(event['resultImageUrl'])
                    : Center(child: Icon(Icons.image, size: 100)),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplyAppealPage(
          event: event 
        ),
      ),
    );
  },
  child: Text('Appeal'),
  style: ElevatedButton.styleFrom(
   // primary: Colors.blueGrey, // Button color
   // onPrimary: Colors.white, // Text color
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  ),
),
              ),
            ],
          ),
        ),
      ),
    );
  }
}