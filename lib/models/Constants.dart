import 'package:flutter/material.dart';
import 'package:messaging_app/models/Conversation.dart';
import 'package:messaging_app/models/Message.dart';

String kDefaultProfilePicture = "https://www.pngkey.com/png/full/202-2024792_user-profile-icon-png-download-fa-user-circle.png";
Color primaryLight = Color(0xFF01A38B);
Color primaryMedium = Color(0xFF006455);
Color primaryDark = Color(0xFF003F35);
Color secondary = Colors.white;

Message dummyMessage = Message(message: "Hi, this is a dummy message!", timeSent: DateTime.now());
List<Conversation> dummyConversations = [
  Conversation(name: "Bible Studies", latestMessage: Message(message: "Hi", timeSent: DateTime.now())),
  Conversation(name: "Holiness is Epic", latestMessage: Message(message: "Nice", timeSent: DateTime.now().subtract(Duration(days: 1)))),
  Conversation(name: "Gimme that 30 bro", latestMessage: Message(message: "Hah?", timeSent: DateTime.now().subtract(Duration(days: 2)))),
  Conversation(name: "Bible is just a history book", latestMessage: Message(message: "Hatdog", timeSent: DateTime.now().subtract(Duration(days: 3)))),
  Conversation(name: "Exam Question Leaks", latestMessage: Message(message: "GG", timeSent: DateTime.now().subtract(Duration(days: 4)))),
  Conversation(name: "Anong Kabostosan Ito?", latestMessage: Message(message: "Talong", timeSent: DateTime.now().subtract(Duration(days: 5)))),
  Conversation(name: "Barkada GC", latestMessage: Message(message: "Ni", timeSent: DateTime.now().subtract(Duration(days: 6)))),
  Conversation(
      name: "Barkada GC w/out that annoying person", latestMessage: Message(message: "Joshua", timeSent: DateTime.now().subtract(Duration(days: 7)))),
  Conversation(name: "Woke shit", latestMessage: Message(message: "Andre", timeSent: DateTime.now().subtract(Duration(days: 8)))),
  Conversation(
      name: "Philosophical Debates that amount to nothing",
      latestMessage: Message(message: "Nicolai", timeSent: DateTime.now().subtract(Duration(days: 9)))),
  Conversation(name: "Conversation Name", latestMessage: Message(message: "Dotiloss", timeSent: DateTime.now().subtract(Duration(days: 31)))),
];

ThemeData appTheme = ThemeData(
  textTheme: TextTheme(
    headline6: TextStyle(color: secondary, fontWeight: FontWeight.bold, fontSize: 15),
    headline3: TextStyle(color: primaryMedium, fontWeight: FontWeight.w700, fontSize: 20, fontFamily: 'Barlow'),
    headline1: TextStyle(color: primaryMedium, fontWeight: FontWeight.w900, fontSize: 45, fontFamily: 'Barlow'),
    bodyText2: TextStyle(color: secondary, fontSize: 15),
    subtitle2: TextStyle(color: Colors.redAccent)
  ),
  primaryColorLight: primaryLight,
  primaryColor: primaryMedium,
  primaryColorDark: primaryDark,
  accentColor: secondary,
  scaffoldBackgroundColor: secondary,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: primaryLight,
      onPrimary: secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: secondary,
      primary: primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
);
