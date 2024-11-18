import 'package:activity_app/pages/events/event_details.dart';
import 'package:activity_app/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventList();
}

class _EventList extends State<EventList> {
  Stream? EventStream;
  List<bool> _favorites = []; // To track favorites for each event

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Future<void> getontheload() async {
    try {
      EventStream = await DatabaseMethods().getEventDetail();
      setState(() {});
    } catch (e) {
      print("Error loading events: $e");
    }
  }

  Future<String?> getCurrentUserId() async {
    User? user =
        FirebaseAuth.instance.currentUser; // Get the current logged-in user
    return user?.uid; // Return the user's unique ID
  }

  Future<void> toggleFavoriteStatus(String eventId, bool isFavorite) async {
    String? userId = await getCurrentUserId(); // Fetch the user ID dynamically
    if (userId != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isFavourite.$eventId': isFavorite,
      });
    } else {
      print("User ID is null. Cannot update favorite status.");
    }
  }

  Widget allEventDetail() {
    return StreamBuilder(
      stream: EventStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text("No events found"));
        }

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            String eventId = ds["ID"];

            // Add the favorite status if not already in _favorites list
            if (_favorites.length <= index) {
              _favorites.add(false); // Default to not favorite
            }

            // Fetch the user's favorite data
            Future<void> fetchFavoriteStatus() async {
              String? userId = await getCurrentUserId();
              if (userId != null) {
                DocumentSnapshot userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get();

                if (userDoc.exists) {
                  Map<String, dynamic> userData =
                      userDoc.data() as Map<String, dynamic>;
                  if (userData.containsKey('isFavourite')) {
                    Map<String, dynamic> isFavourite = userData['isFavourite'];
                    setState(() {
                      _favorites[index] = isFavourite[eventId] ??
                          false; // Set the favorite status
                    });
                  }
                }
              }
            }

            fetchFavoriteStatus(); // Fetch the favorite status for this event

            return Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(20),
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
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            _favorites[index]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            setState(() {
                              _favorites[index] = !_favorites[index];
                            });
                            await toggleFavoriteStatus(
                                eventId, _favorites[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
            ),
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
