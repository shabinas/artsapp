import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event_detail extends StatefulWidget {
  final String evname;
  final String evtime;
  final String evdate;
  final String evstage;
  final String iddata;

  Event_detail({
    super.key, 
    required this.evname, 
    required this.evtime, 
    required this.evdate, 
    required this.evstage, 
    required this.iddata,
  });

  @override
  State<Event_detail> createState() => _Event_detailState();
}

class _Event_detailState extends State<Event_detail> {
  String evid1 = '';
  String eventname1 = '';
  String phone1 = '';

  late TextEditingController _evid;
  late TextEditingController _eventname;
  late TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  fetch() {
    setState(() {
      _evid= TextEditingController(text: evid1);
      _eventname = TextEditingController(text: eventname1);
      _phone = TextEditingController(text: phone1);
    });
  }

  void updateData() async {
    try {
      DocumentReference querySnapshot = FirebaseFirestore.instance.collection('students').doc(widget.iddata);
      querySnapshot.update({
        'name': _evid.text,
        'email': _eventname.text,
        'phone': _phone.text,
      });
    } catch (e) {
      print('Error updating Firestore: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage("https://www.mockofun.com/wp-content/uploads/2019/12/circle-photo.jpg"),
                ),
                Text("Event name: ${widget.evname}"),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Go Back'),
                ),
                Column(
                  children: [
                    TextFormField(
                      controller: _evid,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'ID Number',
                      ),
                    ),
                    TextFormField(
                      controller: _phone,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Phone No',
                      ),
                    ),
                    TextFormField(
                      controller: _eventname,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Assign',
                      ),
                    ),
                    
                    ElevatedButton(
                      onPressed: () {
                        updateData();
                      },
                      child: Text('Assign'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
