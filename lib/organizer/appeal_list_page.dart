import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appeal_detail_page.dart'; // Import AppealDetailPage
import 'update_result.dart'; // Import UpdateResult

class AppealListPage extends StatefulWidget {
  final String eventId;

  const AppealListPage({Key? key, required this.eventId}) : super(key: key);

  @override
  _AppealListPageState createState() => _AppealListPageState();
}

class _AppealListPageState extends State<AppealListPage> {
  late Future<List<Map<String, dynamic>>> appealsFuture;
  String eventName = '';

  @override
  void initState() {
    super.initState();
    _fetchEventName();
    appealsFuture = getEventAppeals();
  }

  Future<void> _fetchEventName() async {
    try {
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance.collection('events').doc(widget.eventId).get();
      if (eventDoc.exists) {
        setState(() {
          eventName = eventDoc['eventName'];
        });
      }
    } catch (e) {
      print('Error fetching event name: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getEventAppeals() async {
    try {
      QuerySnapshot appealQuery = await FirebaseFirestore.instance
          .collection('appeals')
          .where('eventId', isEqualTo: widget.eventId)
          .get();

      List<Map<String, dynamic>> appeals = appealQuery.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['appealId'] = doc.id;
        return data;
      }).toList();

      return appeals;
    } catch (e) {
      print('Error fetching event appeals: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getStudentDetails(String userId) async {
    try {
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(userId)
          .get();

      if (studentDoc.exists) {
        return studentDoc.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching student details: $e');
      return null;
    }
  }

  void _refreshAppeals() {
    setState(() {
      appealsFuture = getEventAppeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Appeal List')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: appealsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(child: Text('No Appeals Found'));
            } else {
              final appeals = snapshot.data ?? [];

              if (appeals.isEmpty) {
                return Center(child: Text('No Appeals Found'));
              }

              return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: appeals.length,
                itemBuilder: (context, index) {
                  var appeal = appeals[index];
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: getStudentDetails(appeal['userId']),
                    builder: (context, studentSnapshot) {
                      if (studentSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (studentSnapshot.hasError) {
                        return Text('Error: ${studentSnapshot.error}');
                      } else {
                        var studentDetails = studentSnapshot.data;
                        return GestureDetector(
                          onTap: () async {
                            if (appeal['status'] == 'Accepted') {
                              // Navigate to UpdateResult page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateResult(
                                    organizerId: appeal['userId'],
                                    eventId: widget.eventId,
                                    eventName: eventName,
                                    videoLink: appeal['videoLink'],
                                    description: appeal['description'],
                                  ),
                                ),
                              );
                            } else {
                              // Navigate to AppealDetailPage
                              appeal['eventName'] = eventName; // Add the event name to appeal data
                              bool? result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppealDetailPage(
                                    appeal: appeal,
                                    eventId: widget.eventId,
                                  ),
                                ),
                              );
                              if (result == true) {
                                _refreshAppeals(); // Refresh appeals if status was updated
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
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
                                      studentDetails?['name'] ?? 'Name',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      studentDetails?['idNumber'] ?? 'ID Number',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(appeal['status']),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    appeal['status'] ?? 'Pending', // Display the status here
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey; // Grey color for 'Pending' or any other unspecified status
    }
  }
}