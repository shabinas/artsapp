import 'package:finearts/organizer/all_event.dart';
import 'package:finearts/organizer/events_result.dart';
import 'package:flutter/material.dart';

class EventPage_Home extends StatefulWidget {
  final String organizerId;

  EventPage_Home({required this.organizerId});

  @override
  State<EventPage_Home> createState() => _EventPage_HomeState();
}

class _EventPage_HomeState extends State<EventPage_Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Container(
              color: Colors.white,
              child: TabBar(
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                labelPadding: EdgeInsets.symmetric(vertical: 0),
                indicator: BoxDecoration(
                  color:  Color(0xFFFFC107) , // Highlighted color
                  borderRadius: BorderRadius.circular(0),
                ),
                unselectedLabelColor: Colors.black,
                labelColor: Colors.black,
                tabs: <Widget>[
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0 ? Color(0xFFFFC107) : Color(0xFFB0BEC5), // Swap colors based on selection
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Event",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIndex == 1 ? Color(0xFFFFC107) : Color(0xFFB0BEC5), // Swap colors based on selection
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Result",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            AllEventsPage(),

            Events_Result(organizerId: widget.organizerId)
          ],
        ),
        
      ),
    );
  }
}

