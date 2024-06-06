import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Event_editpage.dart';

class AssignedEventsList extends StatefulWidget {
  final String organizerId;

  const AssignedEventsList({Key? key, required this.organizerId}) : super(key: key);

  @override
  State<AssignedEventsList> createState() => _AssignedEventsListState();
}

class _AssignedEventsListState extends State<AssignedEventsList> {
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
        title: Text('Assigned Events'),
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
            } else {
              final assignedEvents = snapshot.data!;
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Divider(),
                  );
                },
                itemCount: assignedEvents.length,
                itemBuilder: (context, index) {
                  var event = assignedEvents[index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(85, 141, 187, 1),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            event['eventName'].toString(),
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Date : ${event['date']}', style: TextStyle(color: Colors.white)),
                        Text('Time : ${event['time']}', style: TextStyle(color: Colors.white)),
                        Text('Stage : ${event['stage']}', style: TextStyle(color: Colors.white)),
                        Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await _deleteEvent(event['id']);
                                },
                                icon: Icon(Icons.delete, color: Colors.white, size: 20),
                              ),
                              IconButton(
                                onPressed: () async {
                                  bool? isUpdated = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return EventEditPage(event: event);
                                      },
                                    ),
                                  );
                                  if (isUpdated == true) {
                                    setState(() {});
                                  }
                                },
                                icon: Icon(Icons.edit, color: Colors.white, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
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
