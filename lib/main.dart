import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/screens/conversation_screen.dart';
import 'package:messaging_app/screens/home_screen.dart';
import 'package:messaging_app/screens/landing_screen.dart';
import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/screens/new_conversation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Messaging App', theme: appTheme, home: LandingScreen());
  }
}
