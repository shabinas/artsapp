import 'package:finearts/admin/student_list.dart';
import 'package:finearts/admin/organizer_list.dart';
import 'package:finearts/admin/events_list.dart';
import 'package:finearts/student/student_registration.dart';
import 'package:flutter/material.dart';

class Admin_home extends StatefulWidget {
  const Admin_home({super.key});

  @override
  State<Admin_home> createState() => _Admin_homeState();
}

class _Admin_homeState extends State<Admin_home> {

int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    //class name here
    Student_list(),
    Organizer_list(),
    Events_list(),
    // Text(
    //   'Index 2: Camera',
    //   style: optionStyle,
    // ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      //nav bar start here
      bottomNavigationBar: BottomNavigationBar(
  items: [
    BottomNavigationBarItem(
      icon: Text(
        'Student',
        style: TextStyle(color: _selectedIndex == 0 ? Colors.yellow : Colors.blue),
      ),
      label: '',
      backgroundColor: Colors.blue,
    ),
    BottomNavigationBarItem(
      icon: Text(
        'Organizer',
        style: TextStyle(color: _selectedIndex == 1 ? Colors.yellow : Colors.blue),
      ),
      label: '',
      backgroundColor: Colors.blue,
    ),
    BottomNavigationBarItem(
      icon: Text(
        'Event',
        style: TextStyle(color: _selectedIndex == 2 ? Colors.yellow : Colors.blue),
      ),
      label: '',
      backgroundColor: Colors.blue,
    ),
  ],
  currentIndex: _selectedIndex,
  selectedItemColor: Colors.amber[800],
  onTap: _onItemTapped,
),


    );
  }
}