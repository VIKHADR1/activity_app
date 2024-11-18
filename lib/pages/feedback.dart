import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:activity_app/pages/colors.dart'; // Import your colors

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0;
  String? _feedbackMessage;
  bool _isSubmitted = false;

  void _submitFeedback() {
    setState(() {
      _feedbackMessage = _feedbackController.text;
      _isSubmitted = true;
    });

    // Send the feedback to Firebase Firestore
    FirebaseFirestore.instance.collection('feedback').add({
      'rating': _rating,
      'feedback': _feedbackMessage,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((_) {
      // Optionally show a toast message or snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Feedback submitted successfully!'),
          backgroundColor: AppColors.primaryColor,
        ),
      );
    }).catchError((error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit feedback. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor:
            AppColors.primaryColor, // Using primary color for consistency
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display a title
              Text(
                "We value your feedback",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryColor, // Title text color
                ),
              ),
              SizedBox(height: 20),

              // Rating bar for feedback
              Text(
                "Rate your experience:",
                style: TextStyle(
                    fontSize: 16, color: AppColors.textSecondaryColor),
              ),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color:
                      AppColors.accentColor1, // Accent color for the star icon
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(height: 20),

              // TextField to enter feedback message
              Text(
                "Write your feedback:",
                style: TextStyle(
                    fontSize: 16, color: AppColors.textSecondaryColor),
              ),
              TextField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Enter your comments here...",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors
                            .primaryColor), // Highlight border with primary color
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: _submitFeedback,
                child: Text("Submit Feedback"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors
                      .primaryColor, // Use primary color for the button
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Display feedback message dynamically after submission
              if (_isSubmitted) ...[
                Text(
                  "Thank you for your feedback!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  "Rating: ${_rating.toStringAsFixed(1)} stars",
                  style: TextStyle(
                      fontSize: 16, color: AppColors.textSecondaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  "Your feedback: $_feedbackMessage",
                  style: TextStyle(
                      fontSize: 16, color: AppColors.textSecondaryColor),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
