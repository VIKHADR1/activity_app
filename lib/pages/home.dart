import 'package:activity_app/pages/aboutUs.dart';
import 'package:activity_app/pages/authentication/login.dart';
import 'package:activity_app/pages/caldendar.dart';
import 'package:activity_app/pages/colors.dart';
import 'package:activity_app/pages/events/event_detail_view.dart';
import 'package:activity_app/pages/favourite.dart';
import 'package:activity_app/pages/feedback.dart';
import 'package:activity_app/pages/profile.dart';
import 'package:activity_app/service/database.dart';
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
  Stream? EventStream;
  List<bool> _favorites = [];
  String? selectedCategory;
  String searchQuery = "";
  List<String> categories = [
    'Academic',
    'Sports & Recreation',
    'Arts & Culture',
    'Networking & Career',
    'Community Outreach',
    'Health & Wellness',
    'Technology & Innovation',
    'Sustainability',
    'Social & Entertainment'
  ];

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getFavoriteEventsCount();
    getontheload();
  }

  void _getUserData() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        username = userDoc.get('username') ?? "John Doe";
        email = userDoc.get('email') ?? "john.doe@example.com";
      });
    } else {
      setState(() {
        username = "John Doe"; // Default username if no data found
        email = "john.doe@example.com"; // Default email
      });
    }
  }

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

  // Search bar widget
  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search events...",
          prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
          filled: true,
          fillColor: AppColors.secondaryColor.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget buildCategoryGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.5,
      padding: EdgeInsets.all(10),
      children: categories.map((category) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = selectedCategory == category ? null : category;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: selectedCategory == category
                  ? AppColors.secondaryColor.withOpacity(0.7)
                  : AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primaryColor,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                category,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selectedCategory == category
                      ? AppColors.textSecondaryColor
                      : AppColors.accentColor1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Carousel Slider Widget for the latest three events
  Widget buildCarousel(List<DocumentSnapshot> eventDocs) {
    // Get the latest three events
    final latestThreeEvents = eventDocs.take(3).toList();

    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        autoPlayInterval: Duration(seconds: 3),
      ),
      items: latestThreeEvents.map((ds) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    ds['Name'],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  // Display all event details
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
              style: TextStyle(
                color: AppColors.textSecondaryColor,
                fontSize: 18,
              ),
            ),
          );
        }

        final eventDocs = snapshot.data.docs;

        // Filter events based on search query and selected category
        final filteredEvents = eventDocs.where((ds) {
          final eventName = ds['Name'].toLowerCase();
          final categoryMatch =
              selectedCategory == null || ds['Category'] == selectedCategory;
          final searchMatch =
              searchQuery.isEmpty || eventName.contains(searchQuery);
          return categoryMatch && searchMatch;
        }).toList();

        return Column(
          children: [
            buildSearchBar(), // Search bar
            buildCarousel(eventDocs), // Carousel Slider
            SizedBox(height: 10),
            buildCategoryGrid(),

            Expanded(
              child: ListView.builder(
                itemCount: eventDocs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = filteredEvents[index];
                  String eventId = ds["ID"];

                  // Add the favorite status if not already in _favorites list
                  if (_favorites.length <= index) {
                    _favorites.add(false);
                  }

                  // Fetch the user's favorite data
                  Future<void> fetchFavoriteStatus() async {
                    String? userId = await getCurrentUserId();
                    if (userId != null) {
                      DocumentSnapshot userDoc = await FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(userId)
                          .get();

                      if (userDoc.exists) {
                        Map<String, dynamic> userData =
                            userDoc.data() as Map<String, dynamic>;
                        if (userData.containsKey('isFavourite')) {
                          Map<String, dynamic> isFavourite =
                              userData['isFavourite'];
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
                            category: ds["Category"],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor, // Updated to match LoginPage
        title: Text(
          'Home Page',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textPrimaryColor, // Updated text color
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColors.textPrimaryColor),
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
                  icon: Icon(Icons.notifications,
                      color: AppColors.textPrimaryColor),
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
              accountName: Text(username ?? "Loading..."),
              accountEmail: Text(email ?? "Loading..."),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  username != null && username!.isNotEmpty
                      ? username![0].toUpperCase()
                      : 'U',
                  style:
                      TextStyle(fontSize: 40.0, color: AppColors.primaryColor),
                ),
              ),

              // Add background color here
              decoration: BoxDecoration(
                color: AppColors
                    .primaryColor, // Change this to any color you prefer
              ),
            ),
            ListTile(
              title: Text("Profile",
                  style: TextStyle(color: AppColors.textPrimaryColor)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              title: Text("About Us",
                  style: TextStyle(color: AppColors.textPrimaryColor)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
            ),
            ListTile(
              title: Text("Feedback",
                  style: TextStyle(color: AppColors.textPrimaryColor)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackPage()),
                );
              },
            ),
            ListTile(
              title: Text("Logout",
                  style: TextStyle(color: AppColors.textPrimaryColor)),
              onTap: () {
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
          children: [Expanded(child: allEventDetail())],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
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
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textSecondaryColor,
        backgroundColor: AppColors.secondaryColor,
      ),
    );
  }
}
