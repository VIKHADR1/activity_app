import 'package:flutter/material.dart';
import 'package:activity_app/pages/colors.dart'; // Import the custom colors

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor:
            AppColors.primaryColor, // Use primary color from AppColors
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // App logo or icon (You can replace it with your app logo)
              Center(
                child: Icon(
                  Icons.event_note, // Example icon, replace with your app logo
                  size: 100,
                  color: AppColors.accentColor1, // Accent color for the icon
                ),
              ),
              SizedBox(height: 20),

              // App title
              Text(
                'Activity Tracker App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor, // Primary color for the title
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              // Description about the app
              Text(
                'Welcome to Activity Tracker, an app designed to help you manage and track your school activities. '
                'With this app, you can view your events, mark favorites, categorize your activities, and set reminders. '
                'Stay organized and never miss an important event!',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimaryColor, // Primary text color
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),

              // Mission section
              Text(
                'Our Mission:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors
                      .accentColor1, // Accent color for the mission title
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Our mission is to provide students and educators with an easy-to-use app to track important school activities, '
                'set reminders, and ensure nothing is missed. We aim to promote productivity and organization.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors
                      .textPrimaryColor, // Primary text color for body text
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),

              // Features section
              Text(
                'Features:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      AppColors.accentColor1, // Accent color for features title
                ),
              ),
              SizedBox(height: 10),
              Text(
                '• View and track school activities\n'
                '• Categorize events\n'
                '• Mark important events as favorites\n'
                '• Set reminders for upcoming events\n'
                '• Simple, easy-to-use interface',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors
                      .textPrimaryColor, // Primary text color for the list
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),

              // Contact section
              Text(
                'Contact Us:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      AppColors.accentColor1, // Accent color for contact title
                ),
              ),
              SizedBox(height: 10),
              Text(
                'If you have any questions or feedback, feel free to reach out to us at support@activitytracker.com.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors
                      .textPrimaryColor, // Primary text color for the contact text
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
