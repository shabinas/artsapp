import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventEditPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventEditPage({Key? key, required this.event}) : super(key: key);

  @override
  _EventEditPageState createState() => _EventEditPageState();
}

class _EventEditPageState extends State<EventEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _stageController;
  late TextEditingController _timeController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event['eventName']);
    _dateController = TextEditingController(text: widget.event['date']);
    _stageController = TextEditingController(text: widget.event['stage']);
    _timeController = TextEditingController(text: widget.event['time']);
    _locationController = TextEditingController(text: widget.event['location']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _stageController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('events')
            .doc(widget.event['id'])
            .update({
          'eventName': _nameController.text,
          'date': _dateController.text,
          'stage': _stageController.text,
          'time': _timeController.text,
          'location': _locationController.text,
        });
        Navigator.of(context).pop(true); // Return true to indicate success
      } catch (e) {
        print('Error updating event: $e');
        Navigator.of(context).pop(false); // Return false to indicate failure
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stageController,
                decoration: InputDecoration(labelText: 'Stage No'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter stage number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateEvent,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
