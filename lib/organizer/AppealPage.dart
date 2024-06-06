import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finearts/organizer/appeal_list_page.dart';
import 'package:flutter/material.dart';

class AppealPage extends StatefulWidget {
  final String organizerId;

  const AppealPage({Key? key, required this.organizerId}) : super(key: key);

  @override
  State<AppealPage> createState() => _AppealPageState();
}

class _AppealPageState extends State<AppealPage> {
  Future<List<Map<String, dynamic>>> getAssignedEvents() async {
    try {
      DocumentSnapshot organizerDoc = await FirebaseFirestore.instance
          .collection('organizers')
          .doc(widget.organizerId)
          .get();

      List<String> assignedEventIds = List<String>.from(organizerDoc['assignedEvents'] ?? []);
      List<Map<String, dynamic>> assignedEvents = [];

      for (String eventId in assignedEventIds) {
        DocumentSnapshot eventDoc = await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .get();
        if (eventDoc.exists) {
          assignedEvents.add({...eventDoc.data() as Map<String, dynamic>, 'id': eventDoc.id});
        }
      }

      return assignedEvents;
    } catch (e) {
      print('Error fetching assigned events: $e');
      throw e;
    }
  }

  Future<void> _deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
      setState(() {});
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Appeal')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: getAssignedEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(child: Text('No Events Found'));
            } else {
              final assignedEvents = snapshot.data!;
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                  );
                },
                itemCount: assignedEvents.length,
                itemBuilder: (context, index) {
                  var event = assignedEvents[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AppealListPage(eventId: event['id'])),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              event['eventName'].toString(),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}