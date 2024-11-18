import 'package:activity_app/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:activity_app/pages/events/event_details.dart';
import 'package:flutter/widgets.dart';

// Stateful widget to display the list of events
class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventList();
}

class _EventList extends State<EventList> {
  // Stream to retrieve event details from Firestore
  Stream? EventStream;

  // Asynchronous function to load event details from the database
  getontheload() async {
    EventStream = await DatabaseMethods().getEventDetail();
    setState(() {}); // Update the UI once data is loaded
  }

  // Initialize state and load events when the widget is first created
  @override
  void initState() {
    getontheload();
    super.initState();
  }

  // Widget to build a list view of all event details using a StreamBuilder
  Widget allEventDetail() {
    return StreamBuilder(
        stream: EventStream,
        builder: (context, AsyncSnapshot snapshot) {
          // Check if snapshot has data; if so, build a list of events
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    // Access each document snapshot from Firestore
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Material(
                        elevation: 5, // Add elevation for shadow effect
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 190, 166, 255),
                              borderRadius: BorderRadius.circular(10)),
                          // Display event details
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Event Name: " + ds["Name"],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Description: " + ds["Description"],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Contact Info: " + ds["Contact Info"],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Contact Info: " + ds["Contact Info"],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container(); // Show an empty container if there's no data
        });
  }

  // Main build method to render the EventList screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Floating action button to navigate to EventDetail page for adding new events
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EventDetail()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        // AppBar title with customized text styling
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Activity',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Tracker',
              style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      // Body container to hold the event list with padding
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            Expanded(child: allEventDetail())
          ], // Expanded to fill available space
        ),
      ),
    );
  }
}
