import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/database/flutterfire.dart';

import '../models/Message.dart';
import './image_message.dart';
import './text_message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final Color color;

  const ChatBubble({this.message, this.color});

  Future<String> getMemberName() async {
    return message.senderId != FirebaseAuth.instance.currentUser.uid
        ? await getName(message.senderId)
        : "";
  }

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser.uid;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0, bottom: 3.0),
          child: FutureBuilder(
              future: getMemberName(),
              builder: (_, snapshot) {
                return !snapshot.hasData
                    ? SizedBox()
                    : Text(
                        snapshot.data,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                      );
              }),
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: _buildBoxDecoration(userID, context),
          child: message.label == "text"
              ? TextMessage(message: message, color: color)
              : ImageMessage(message: message),
        ),
      ],
    );
  }

  BoxDecoration _buildBoxDecoration(String userID, BuildContext context) {
    return BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(message.senderId == userID ? 12 : 0),
          bottomRight: Radius.circular(message.senderId == userID ? 0 : 12),
        ),
        color: message.senderId != userID
            ? Theme.of(context).primaryColorLight
            : Colors.grey[300]);
  }
}
