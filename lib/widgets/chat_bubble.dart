import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/models/Message.dart';

class ChatBubble extends StatelessWidget {
  final List<Message> messages;
  final index, color;

  const ChatBubble({this.messages, this.index, this.color});

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser.uid;
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft:
                Radius.circular(messages[index].senderId == userID ? 12 : 0),
            bottomRight:
                Radius.circular(messages[index].senderId == userID ? 0 : 12),
          ),
          color: messages[index].senderId != userID
              ? Theme.of(context).primaryColorLight
              : Colors.grey[300]),
      child: messages[index].label == "text"
          ? Text(messages[index].message, style: TextStyle(color: color))
          : Container(
              constraints: BoxConstraints(
                  minHeight: 100.0,
                  minWidth: 100.0,
                  maxHeight: 200.0,
                  maxWidth: 200.0),
              child: Image(
                  image: NetworkImage(messages[index].message),
                  fit: BoxFit.cover)),
    );
  }
}
