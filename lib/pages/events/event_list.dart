import 'package:activity_app/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:activity_app/pages/events/event_details.dart';
import 'package:flutter/widgets.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventList();
}

class _EventList extends State<EventList> {
  Stream? EventStream;

  getontheload() async {
    EventStream = await DatabaseMethods().getEventDetail();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allEventDetail() {
    return StreamBuilder(
        stream: EventStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 190, 166, 255),
                              borderRadius: BorderRadius.circular(10)),
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
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
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
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [Expanded(child: allEventDetail())],
        ),
      ),
    );
  }
}
