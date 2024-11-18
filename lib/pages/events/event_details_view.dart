import 'package:flutter/material.dart';

class EventDetailView extends StatelessWidget {
  final String eventName;
  final String eventDescription;
  final String contactInfo;
  final String category;

  const EventDetailView({
    Key? key,
    required this.eventName,
    required this.eventDescription,
    required this.contactInfo,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          eventName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.deepPurple[50], // Light purple background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name as a Banner with Elevated Style
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  eventName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Event Category with an Icon
              _buildDetailSection(
                icon: Icons.category,
                title: 'Category:',
                content: category,
              ),
              SizedBox(height: 20),

              // Event Description with Card Style
              _buildDetailSection(
                icon: Icons.description,
                title: 'Description:',
                content: eventDescription,
                isCard: true,
              ),
              SizedBox(height: 20),

              // Contact Info with an Icon
              _buildDetailSection(
                icon: Icons.contact_phone,
                title: 'Contact Info:',
                content: contactInfo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable method to create the styled sections
  Widget _buildDetailSection({
    required IconData icon,
    required String title,
    required String content,
    bool isCard = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple, size: 24),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
