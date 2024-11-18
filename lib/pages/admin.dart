import 'package:activity_app/pages/authentication/login.dart';
import 'package:activity_app/service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:activity_app/pages/colors.dart'; // Import your login page

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  // Controllers for the event name, description, and contact info fields
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController contactInfoController = new TextEditingController();

  // Variable to store the selected category
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar title with custom styling and color for each word
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Activity',
              style: TextStyle(
                  color: AppColors.primaryColor, // Primary color
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Tracker',
              style: TextStyle(
                  color: AppColors.accentColor1, // Accent color
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        backgroundColor:
            AppColors.primaryColor, // Use primary color for AppBar background

        // Add a back button to the app bar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate back to the login page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LoginPage()), // Adjust the route to your login page
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name label and input field
              Text(
                'Event Name',
                style: TextStyle(
                    color: AppColors.textPrimaryColor, // Primary text color
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          AppColors.primaryColor), // Border using primary color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Description label and input field
              Text(
                'Description',
                style: TextStyle(
                    color: AppColors.textPrimaryColor, // Primary text color
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Contact Info label and input field
              Text(
                'Contact Info',
                style: TextStyle(
                    color: AppColors.textPrimaryColor, // Primary text color
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: contactInfoController,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Category label and dropdown list
              Text(
                'Category',
                style: TextStyle(
                    color: AppColors.textPrimaryColor, // Primary text color
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: selectedCategory,
                  hint: Text('Select a category',
                      style: TextStyle(color: AppColors.textSecondaryColor)),
                  isExpanded: true,
                  icon:
                      Icon(Icons.arrow_downward, color: AppColors.primaryColor),
                  style: TextStyle(
                      color: AppColors.textPrimaryColor, fontSize: 16),
                  underline: SizedBox.shrink(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  items: [
                    'Academic',
                    'Sports & Recreation',
                    'Arts & Culture',
                    'Networking & Career Development',
                    'Community Outreach',
                    'Health & Wellness',
                    'Technology & Innovation',
                    'Sustainability & Environment',
                    'Social & Entertainment'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Centered button for submitting event details
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Generate a random ID for the event
                    String Id = randomAlphaNumeric(10);
                    // Map to store event details
                    Map<String, dynamic> eventDetailMap = {
                      "Name": nameController.text,
                      "Description": descriptionController.text,
                      "ID": Id,
                      "Contact Info": contactInfoController.text,
                      "Category": selectedCategory, // Store selected category
                    };
                    // Add event details to Firestore and show a confirmation toast
                    await DatabaseMethods()
                        .addEventDetail(eventDetailMap, Id)
                        .then((value) {
                      Fluttertoast.showToast(
                          msg: "Event detail has been added successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor:
                              AppColors.primaryColor, // Primary color
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.accentColor1, // Accent color for button
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Add Event',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors
                            .textPrimaryColor), // Text color for button
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
