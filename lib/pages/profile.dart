import 'package:activity_app/pages/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? email;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    // Fetch user details from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users') // Adjust this collection name if needed
        .doc(userId)
        .get();

    if (userDoc.exists) {
      setState(() {
        username = userDoc['username'] ?? "Unknown";
        email = userDoc['email'] ?? "No email found";
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("lib/assets/profile.jpg"),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    username ?? "Loading...",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    email ?? "Loading...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
