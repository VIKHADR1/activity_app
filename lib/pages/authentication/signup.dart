import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../colors.dart'; // Import your color palette

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor, // Use primary color
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center everything
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter your username', // Simple placeholder text
                  hintStyle: TextStyle(
                      color: AppColors.textSecondaryColor), // Placeholder color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: AppColors.secondaryColor, // Fill color
                ),
                style: TextStyle(
                    color: AppColors.textPrimaryColor), // Custom text color
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email', // Simple placeholder text
                  hintStyle: TextStyle(
                      color: AppColors.textSecondaryColor), // Placeholder color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: AppColors.secondaryColor, // Fill color
                ),
                style: TextStyle(
                    color: AppColors.textPrimaryColor), // Custom text color
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Enter your password', // Simple placeholder text
                  hintStyle: TextStyle(
                      color: AppColors.textSecondaryColor), // Placeholder color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: AppColors.secondaryColor, // Fill color
                ),
                obscureText: true,
                style: TextStyle(
                    color: AppColors.textPrimaryColor), // Custom text color
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        final User? user = userCredential.user;
                        if (user != null) {
                          // Add the username to the Firebase Authentication user.
                          await user
                              .updateDisplayName(_usernameController.text);

                          // Save user data to Firestore
                          await saveUserDataToFirestore(user.uid);
                        }
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('The password provided is too weak.')),
                          );
                        } else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'The account already exists for that email.')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('An error occurred during sign up.')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryColor, // Custom button color
                    elevation: 5, // Add elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> saveUserDataToFirestore(String userId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('users').doc(userId).set({
        'username': _usernameController.text,
        'email': _emailController.text,
        // You can add more fields as needed
      });
    } catch (e) {
      print('Error saving user data to Firestore: $e');
    }
  }
}
