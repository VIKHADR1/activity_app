import 'package:activity_app/pages/caldendar.dart';
import 'package:activity_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:activity_app/pages/colors.dart'; // Ensure you import your colors file

class Favourite extends StatefulWidget {
  final String userId;

  Favourite({required this.userId});

  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  int _selectedIndex = 1;

  Future<List<Map<String, dynamic>>> fetchFavoriteEvents() async {
    if (widget.userId.isEmpty) {
      print("Error: userId is empty");
      return [];
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        final favoriteMap =
            userDoc.data()?['isFavourite'] as Map<String, dynamic>?;

        if (favoriteMap != null) {
          final favoriteEventIds = favoriteMap.entries
              .where((entry) => entry.value == true)
              .map((entry) => entry.key)
              .toList();

          if (favoriteEventIds.isNotEmpty) {
            final eventDetails = await FirebaseFirestore.instance
                .collection('EventDetail')
                .where('ID', whereIn: favoriteEventIds)
                .get();

            return eventDetails.docs
                .map((doc) => {
                      'Name': doc.data()['Name'],
                      'Description': doc.data()['Description'],
                      'Contact Info': doc.data()['Contact Info'],
                      'Image': doc.data()['Image'] ??
                          'https://via.placeholder.com/150', // Add image URL if available
                    })
                .toList();
          }
        }
      }
    } catch (e) {
      print("Error fetching favorite events: $e");
    }
    return [];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Calendar()),
      );
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        backgroundColor: AppColors.primaryColor, // Use primary color
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Displaying favorite events
        future: fetchFavoriteEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator(color: AppColors.accentColor1));
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error fetching data",
                    style: TextStyle(color: AppColors.textPrimaryColor)));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
                child: Text("No favorite events",
                    style: TextStyle(color: AppColors.textPrimaryColor)));
          } else {
            final favoriteEvents = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: favoriteEvents.length,
              itemBuilder: (context, index) {
                var event = favoriteEvents[index];
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  color: AppColors.secondaryColor, // Card background color
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    // Removed the leading image
                    title: Text(
                      event['Name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color:
                            AppColors.textPrimaryColor, // Text color for title
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          event['Description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColors
                                  .textSecondaryColor), // Secondary text color
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Contact Info: ${event['Contact Info']}",
                          style: TextStyle(
                              color: AppColors
                                  .accentColor2), // Accent color for contact info
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.favorite,
                      color: AppColors
                          .accentColor2, // Accent color for favorite icon
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            AppColors.secondaryColor, // Background color of the bottom nav bar
        selectedItemColor: AppColors.primaryColor, // Active item color
        unselectedItemColor:
            AppColors.textSecondaryColor, // Inactive item color
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
