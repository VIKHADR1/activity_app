import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App logo or icon can go here if desired
              Center(
                child: Icon(
                  Icons
                      .access_alarm, // Example icon, replace with your app logo
                  size: 100,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Activity Tracker App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Welcome to Activity Tracker, an app designed to help you manage and track your school activities. With this app, you can view your events, mark favorites, categorize your activities, and set reminders. Stay organized and never miss an important event!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Our Mission:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Our mission is to provide students and educators with an easy-to-use app to track important school activities, set reminders, and ensure nothing is missed. We aim to promote productivity and organization.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Features:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '• View and track school activities\n• Categorize events\n• Mark important events as favorites\n• Set reminders for upcoming events\n• Simple, easy-to-use interface',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Contact Us:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'If you have any questions or feedback, feel free to reach out to us at support@activitytracker.com.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
