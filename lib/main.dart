// ignore_for_file: prefer_const_constructors

import 'package:activity_app/pages/events/event_list.dart';
import 'package:activity_app/firebase_options.dart';
import 'package:activity_app/pages/admin.dart';
import 'package:activity_app/pages/home.dart';
import 'package:activity_app/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const EventList(),
      routes: {
        '/home': (context) => const UserHomePage(),
        '/adminpanel': (context) => const AdminPanel(),
      },
    );
  }
}
