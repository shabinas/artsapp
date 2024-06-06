import 'package:finearts/organizer/AppealPage.dart';
import 'package:finearts/organizer/events_home.dart';
import 'package:flutter/material.dart';
import 'AssignedEventsList.dart';

class HomePage extends StatefulWidget {
  final String organizerId;

  const HomePage({Key? key, required this.organizerId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.add(AssignedEventsList(organizerId: widget.organizerId));
    _pages.add(EventPage_Home(organizerId: widget.organizerId));
    _pages.add(AppealPage(organizerId: widget.organizerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
         backgroundColor: Color.fromRGBO(32, 69, 99, 1), 
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber, // Set selected item color
        unselectedItemColor: Colors.white, // Set unselected item color
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: _currentIndex == 0 ? Colors.amber : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text("Assigned", style: TextStyle(color: Colors.white)),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: _currentIndex == 1 ? Colors.amber : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text("Event", style: TextStyle(color: Colors.white)),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: _currentIndex == 2 ? Colors.amber : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text("Appeal", style: TextStyle(color: Colors.white)),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
