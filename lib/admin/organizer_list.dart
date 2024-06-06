import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finearts/admin/event_assign_to_org.dart';
import 'package:flutter/material.dart';
import 'package:finearts/admin/organizer_detail.dart';

class Organizer_list extends StatefulWidget {
  const Organizer_list({super.key});

  @override
  State<Organizer_list> createState() => _Organizer_listState();
}

class _Organizer_listState extends State<Organizer_list> {
  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('organizers')
              //.where('gender', isEqualTo: 'female')
              .get();
      return querySnapshot;
    } catch (e) {
      print('Error querying Firestore: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organizers List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            FutureBuilder(
                future: getData(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final l1 = snapshot.data!.docs;
                    return Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            // child: Divider(),
                          ); // use containers also
                        },
                        itemCount: l1.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey), // Adding border to each item
                              borderRadius: BorderRadius.circular(
                                  10.0), // Optional: Adding border radius for a rounded look
                            ),
                            child: ListTile(
                              onTap: () {
                                if (l1[index]['status'] == 'Accepted') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Events_Assign_Org(
                                        name: l1[index]['name'],
                                        idNumber: l1[index]['idNumber'],
                                        phone: l1[index]['phone'],
                                       // assignedEvents:l1[index]['assignedEvents'],
                                        iddata: l1[index].id,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Organizer_detail(
                                        name: l1[index]['name'],
                                        idNumber: l1[index]['idNumber'],
                                        phone: l1[index]['phone'],
                                        iddata: l1[index].id,
                                      ),
                                    ),
                                  );
                                }
                              },
                              title: Text(
                                l1[index]['name'].toString(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(l1[index]['idNumber'].toString()),
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue, // Adding blue background color
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://shabinas.com/wp-content/uploads/2023/10/Grid-Layout-Design-jpg.webp"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              trailing: Text(
                                l1[index]['status'].toString(),
                                style: TextStyle(
                                  color: l1[index]['status'] == 'Accepted'
                                      ? Colors.green
                                      : l1[index]['status'] == 'Rejected'
                                          ? Colors.red
                                          : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
