import 'package:activity_app/pages/colors.dart';
import 'package:activity_app/pages/events/event_detail_view.dart';
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
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid; // Return the user's unique ID
  }

  Future<void> toggleFavoriteStatus(String eventId, bool isFavorite) async {
    String? userId = await getCurrentUserId();
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
          return Center(
            child: CircularProgressIndicator(color: AppColors.accentColor1),
          );
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: Text(
              "No events found",
              style:
                  TextStyle(color: AppColors.textSecondaryColor, fontSize: 18),
            ),
          );
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
                      _favorites[index] = isFavourite[eventId] ?? false;
                    });
                  }
                }
              }
            }

            fetchFavoriteStatus();

            return GestureDetector(
              onTap: () {
                // Navigate to the event detail page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailView(
                      eventName: ds["Name"],
                      eventDescription: ds["Description"],
                      contactInfo: ds["Contact Info"],
                      category:
                          ds["Category"], // Assuming you have a category field
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColors
                          .secondaryColor, // Event card background color
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Event Name: " + ds["Name"],
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _favorites[index]
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: AppColors.accentColor2,
                              ),
                              onPressed: () async {
                                setState(() {
                                  _favorites[index] = !_favorites[index];
                                });
                                await toggleFavoriteStatus(
                                    eventId, _favorites[index]);
                              },
                            ),
                          ],
                        ),
                        Text(
                          "Description: " + ds["Description"],
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
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
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Activity',
              style: TextStyle(
                color: AppColors.accentColor1,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Tracker',
              style: TextStyle(
                color: AppColors.textSecondaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [Expanded(child: allEventDetail())],
        ),
      ),
    );
  }
}
