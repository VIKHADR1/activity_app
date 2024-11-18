import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  File? _profileImage;
  bool isLoading = false;

  // To save the profile updates
  void _saveProfile() async {
    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username cannot be empty!")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

      // Save username and profile picture URL to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'username': _usernameController.text,
        // If a profile image is selected, upload it (implement image upload logic if required)
      });

      // For simplicity, assuming no image upload logic here
      // To update the profile picture, use Firebase Storage (if necessary)

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile image
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : AssetImage("lib/assets/profile.jpg")
                              as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Username input
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Save button
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text("Save Profile"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
