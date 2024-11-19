import 'package:flutter/material.dart';
import '../colors.dart'; // Import your custom color palette

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
          'Event Details', // Show "Event Details" as the app bar title
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.textPrimaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor, // Use custom primary color
      ),
      backgroundColor: AppColors.backgroundColor, // Light gray background
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
                  color: AppColors.primaryColor, // Dark blue background
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  eventName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text on the banner
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
        color: AppColors
            .accentColor1, // Accent color for the section (Earthy green)
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
                Icon(icon,
                    color: AppColors.primaryColor,
                    size: 24), // Use primary color for icons
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        AppColors.primaryColor, // Primary color for title text
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color:
                    AppColors.textSecondaryColor, // Light gray for content text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
