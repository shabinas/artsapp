import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finearts/admin/student_detail.dart';
import 'package:flutter/material.dart';

class Student_list extends StatefulWidget {
  const Student_list({super.key});

  @override
  State<Student_list> createState() => _Student_listState();
}

class _Student_listState extends State<Student_list> {
  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('students')
              //.where('gender',isEqualTo: 'female')
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
        title: Text('Students List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            FutureBuilder(
                future: getData(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error:${snapshot.error}');
                  } else {
                    final l1 = snapshot.data!.docs;
                    return Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                           // child: Divider(),
                          ); // use cotainers also
                        },
                        itemCount: l1.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      Colors.grey), // Adding border to each item
                              borderRadius: BorderRadius.circular(
                                  10.0), // Optional: Adding border radius for a rounded look
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder:(context) {
                                return Student_detail(name:l1[index]['name'],idNumber:l1[index]['idNumber'],department:l1[index]['department'],phone:l1[index]['phone'],idData:l1[index].id);
                                },),);
                              },
                              title: Text(
                                l1[index]['name'].toString(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(l1[index]['idNumber'].toString()),
                              // leading: CircleAvatar(backgroundImage: NetworkImage (l1[index]['image'].toString()),),
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color:
                                      Colors.blue, // Adding blue background color
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

        
                              // trailing: SizedBox(
                              //   width: 90,
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       IconButton(
                              //           onPressed: () async {
                              //             await FirebaseFirestore.instance
                              //                 .collection('users')
                              //                 .doc(l1[index].id)
                              //                 .delete();
                              //             setState(() {});
                              //           },
                              //           icon: Icon(Icons.delete)),
                              //       // SizedBox(child: Text(l1[index]['gender'].toString())),
                              //       Row(
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //       ),
                              //     ],
                              //   ),
                              // ),
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
