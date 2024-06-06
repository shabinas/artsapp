import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finearts/admin/create_evet.dart';
import 'package:finearts/admin/event_detail.dart';
import 'package:flutter/material.dart';

class Events_list extends StatefulWidget {
  const Events_list({Key? key}) : super(key: key);

  @override
  State<Events_list> createState() => _Events_listState();
}

class _Events_listState extends State<Events_list> {
  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('events').get();
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
        title: Text('Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error:${snapshot.error}');
            } else {
              final l1 = snapshot.data!.docs;
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Divider(),
                  ); // use containers also
                },
                itemCount: l1.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(85, 141, 187, 1), // Adding blue background color
                      border: Border.all(
                        color: Colors.grey,
                      ), // Adding border to each item
                      borderRadius: BorderRadius.circular(10.0), // Optional: Adding border radius for a rounded look
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Event_detail(
                                evname: l1[index]['eventName'],
                                evtime: l1[index]['time'],
                                evdate: l1[index]['date'],
                                evstage: l1[index]['stage'],
                                iddata: l1[index].id,
                              );
                            },
                          ),
                        );
                      },
                      title: Center(
                        child: Text(
                          l1[index]['eventName'].toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Change text color to white for better contrast
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${l1[index]['date']}', style: TextStyle(color: Colors.white)), 
                          Text('Time: ${l1[index]['time']}', style: TextStyle(color: Colors.white)), // Change text color to white for better contrast
                          Text('Stage: ${l1[index]['stage']}', style: TextStyle(color: Colors.white)), // Change text color to white for better contrast
                        ],
                      ),
                      // leading: Container(
                      //   height: 50,
                      //   width: 50,
                      //   decoration: BoxDecoration(
                      //     color: Colors.blue, // Adding blue background color
                      //     image: DecorationImage(
                      //       image: NetworkImage("https://shabinas.com/wp-content/uploads/2023/10/Grid-Layout-Design-jpg.webp"),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      trailing: SizedBox(
                        width: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('events') // Corrected collection name to 'events'
                                    .doc(l1[index].id)
                                    .delete();
                                setState(() {});
                              },
                              icon: Icon(Icons.delete, color: Colors.black), 
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return CreateEvent();
            }),
          );
        },
        backgroundColor: Colors.yellow, // Change background color to yellow
        child: Icon(
          Icons.add,
          size: 36, // Increase icon size to 36
          color: Colors.white, // Change icon color to white
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
