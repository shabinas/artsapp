import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Events_Assign_Org extends StatefulWidget {
  final String name;
  final String idNumber;
  final String phone;
  final String iddata;

  const Events_Assign_Org({
    super.key,
    required this.name,
    required this.idNumber,
    required this.phone,
    required this.iddata,
  });

  @override
  State<Events_Assign_Org> createState() => _Events_Assign_OrgState();
}

class _Events_Assign_OrgState extends State<Events_Assign_Org> {
  late TextEditingController _nameController;
  late TextEditingController _idNumberController;
  late TextEditingController _phoneController;
  List<DocumentSnapshot> _events = [];
  Map<String, bool> _selectedEvents = {};
  List<String> _assignedEventNames = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _idNumberController = TextEditingController(text: widget.idNumber);
    _phoneController = TextEditingController(text: widget.phone);
    _fetchEvents();
    _fetchAssignedEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('events').get();
      setState(() {
        _events = snapshot.docs;
        for (var event in _events) {
          _selectedEvents[event.id] = false;
        }
      });
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  Future<void> _fetchAssignedEvents() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('organizers')
          .doc(widget.iddata)
          .get();
      List<String> assignedEventIds = List<String>.from(doc['assignedEvents'] ?? []);
      
      // Fetch event names for assigned event IDs
      List<String> assignedEventNames = [];
      for (var eventId in assignedEventIds) {
        DocumentSnapshot eventDoc = await FirebaseFirestore.instance.collection('events').doc(eventId).get();
        if (eventDoc.exists) {
          assignedEventNames.add(eventDoc['eventName']);
          _selectedEvents[eventId] = true;
        }
      }

      setState(() {
        _assignedEventNames = assignedEventNames;
      });
    } catch (e) {
      print('Error fetching assigned events: $e');
    }
  }

  void _saveAssignedEvents() async {
    try {
      // Get the selected event IDs
      List<String> selectedEventIds = _selectedEvents.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      // Update the organizer document in Firestore
      await FirebaseFirestore.instance
          .collection('organizers')
          .doc(widget.iddata)
          .update({
        'assignedEvents': selectedEventIds,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Events assigned successfully!'),
      ));

      // Optionally navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      print('Error assigning events: $e');
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to assign events. Please try again later.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idNumberController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Events to Organizer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _idNumberController,
              decoration: InputDecoration(
                labelText: 'ID Number',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Assigned Events:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._assignedEventNames.map((eventName) => Text(eventName)).toList(),
            SizedBox(height: 32),
            Text(
              'Select Events to Assign',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _events.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        var event = _events[index];
                        return CheckboxListTile(
                          title: Text(event['eventName']),
                          value: _selectedEvents[event.id],
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedEvents[event.id] = value ?? false;
                            });
                          },
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: _saveAssignedEvents,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
