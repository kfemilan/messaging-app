import 'package:flutter/material.dart';
import 'package:messaging_app/models/Conversation.dart';
import 'package:messaging_app/models/Message.dart';

Color primaryLight = Color(0xFF01A38B);
Color primaryMedium = Color(0xFF006455);
Color primaryDark = Color(0xFF003F35);
Color secondary = Colors.white;

List<Conversation> dummyConversations = [
  Conversation(messages: [Message(message: "Hi", timeSent: DateTime.now())]),
  Conversation(messages: [Message(message: "Nice", timeSent: DateTime.now())]),
  Conversation(messages: [Message(message: "Hah?", timeSent: DateTime.now())]),
  Conversation(messages: [Message(message: "Hatdog", timeSent: DateTime.now())]),
  Conversation(messages: [Message(message: "GG", timeSent: DateTime.now())]),
];
