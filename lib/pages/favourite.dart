import 'package:activity_app/pages/caldendar.dart';
import 'package:activity_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFavoriteEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(child: Text("No favorite events"));
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
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(
                      event['Name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Contact Info: ${event['Contact Info']}",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
