import 'package:activity_app/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:activity_app/pages/events/event_details.dart';
import 'package:activity_app/pages/events/event_detail_view.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventList();
}

class _EventList extends State<EventList> {
  Stream? eventStream;

  getontheload() async {
    eventStream = await DatabaseMethods().getEventDetail();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allEventDetail() {
    return StreamBuilder(
        stream: eventStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the EventDetailView with event data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailView(
                              eventName: ds["Name"],
                              eventDescription: ds["Description"],
                              contactInfo: ds["Contact Info"],
                              category: ds["Category"],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 190, 166, 255),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Event Name: ${ds["Name"]}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Description: ${ds["Description"]}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                Text(
                                  "Contact Info: ${ds["Contact Info"]}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EventDetail()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Activity',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            Text(
              'Tracker',
              style: TextStyle(
                  color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: allEventDetail(),
      ),
    );
  }
}
