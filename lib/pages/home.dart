import 'package:activity_app/pages/aboutUs.dart';
import 'package:activity_app/pages/authentication/login.dart';
import 'package:activity_app/pages/caldendar.dart';
import 'package:activity_app/pages/events/event_list.dart';
import 'package:activity_app/pages/favourite.dart';
import 'package:activity_app/pages/feedback.dart';
import 'package:activity_app/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int notificationCount = 0;
  String? username;
  String? email;
  // String? profilePictureUrl;

  final List<String> categories = [
    'Sport',
    'Conference',
    'Workshop',
    'Environment & Sustainable Activity',
    'Club Activity',
    'Social & Recreational Activity'
  ];
  final List<String> messages = [
    "Message 1",
    "Message 2",
    "Message 3",
    "Message 4"
  ];

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getFavoriteEventsCount();
  }

  // Inside the _HomePageState class
  void _getUserData() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        username = userDoc['username'] ?? "John Doe";
        email = userDoc['email'] ?? "john.doe@example.com";
        // profilePictureUrl = userDoc['profile']; // If you want to include the profile picture URL
      });
    } else {
      setState(() {
        username = "John Doe"; // Default username if no data found
        email = "john.doe@example.com"; // Default email
      });
    }
  }

  void _updateUsername(String newUsername) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    // Update the username in Firestore
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'username': newUsername,
    });

    // Now, update the local state to reflect the change
    setState(() {
      username = newUsername;
    });

    _getUserData();
  }

  // Get count of favorite events from Firestore
  void _getFavoriteEventsCount() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      var favoriteMap = userDoc['isFavourite'];

      if (favoriteMap is Map) {
        int count = 0;
        favoriteMap.forEach((key, value) {
          if (value == true) {
            count++;
          }
        });

        setState(() {
          notificationCount = count;
        });
      } else {
        setState(() {
          notificationCount = 0;
        });
      }
    } else {
      setState(() {
        notificationCount = 0;
      });
    }
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
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Favourite(
            userId: FirebaseAuth.instance.currentUser?.uid ?? "",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Home Page'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Tooltip(
            message: "Notifications",
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Favourite(
                          userId: FirebaseAuth.instance.currentUser?.uid ?? "",
                        ),
                      ),
                    );
                  },
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16.0,
                        minHeight: 16.0,
                      ),
                      child: Text(
                        notificationCount > 9 ? '9+' : '$notificationCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(username ??
                  "Loading..."), // Shows 'Loading...' while fetching
              accountEmail: Text(
                  email ?? "Loading..."), // Shows 'Loading...' while fetching
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    username != null && username!.isNotEmpty
                        ? username![0].toUpperCase() // First letter of username
                        : 'U', // Default placeholder
                    style: TextStyle(fontSize: 40.0, color: Colors.blue),
                  )
                  // Fallback if no profile picture
                  ),
            ),
            ListTile(
              title: Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
                title: Text("About Us"),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("About Us clicked")),
                  );
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutUsPage()));
                }),
            ListTile(
              title: Text("Feedback"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Feedback clicked")),
                );
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackPage()));
              },
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("You have logged out the account!!")),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SizedBox(
                height: 40.0,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.only(top: 12.0),
                  ),
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
              ),
              items: messages.map((message) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      message,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 50),
            Text(
              'Select a Category:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventList()),
                    );
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 3) - 15,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }
}
