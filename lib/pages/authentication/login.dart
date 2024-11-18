import 'package:activity_app/pages/admin.dart';
import 'package:activity_app/pages/authentication/forgotpw.dart';
import 'package:activity_app/pages/home.dart';
import 'package:activity_app/pages/authentication/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor, // Use primary color
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center everything
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.textPrimaryColor, // Text color
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32.0),
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
                keyboardType: TextInputType.emailAddress, // Email keyboard
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
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    if (email.isNotEmpty && password.isNotEmpty) {
                      try {
                        User? user = (await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        ))
                            .user;

                        if (user!.email == 'asd@gmail.com') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminPanel()),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${e.message}')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please enter your email and password')),
                      );
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
                    'Login',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    color: Color.fromARGB(255, 11, 102, 176),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage()),
                  );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color.fromARGB(255, 11, 102, 176),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 50.0), // Add margin of 50 to the bottom
            ],
          ),
        ),
      ),
    );
  }
}
