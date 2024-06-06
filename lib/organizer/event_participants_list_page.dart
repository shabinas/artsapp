import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventParticipantsListPage extends StatelessWidget {
  final String eventId;

  EventParticipantsListPage({required this.eventId});

  Future<List<Map<String, dynamic>>> _fetchParticipants(List<dynamic> participantIds) async {
    List<Map<String, dynamic>> participants = [];
    
    for (String participantId in participantIds) {
      DocumentSnapshot participantDoc = await FirebaseFirestore.instance.collection('students').doc(participantId).get();
      if (participantDoc.exists) {
        participants.add(participantDoc.data() as Map<String, dynamic>);
      }
    }
    return participants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participants List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('events').doc(eventId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final event = snapshot.data!;
            final participantIds = event['participants'] ?? [];

            if (participantIds.isEmpty) {
              return Center(child: Text('No participants found'));
            }

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchParticipants(participantIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final participants = snapshot.data ?? [];

                return ListView.separated(
                  itemCount: participants.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final participant = participants[index];
                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                participant['name'] ?? 'Name',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                participant['idNumber'] ?? 'ID Number',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}