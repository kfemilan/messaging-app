import 'package:flutter/material.dart';
import 'package:messaging_app/models/Message.dart';

class ChatBubble extends StatelessWidget {
  final List<Message> messages;
  final index, color;

  const ChatBubble({this.messages, this.index, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft:
                  Radius.circular(messages[index].senderId == 00 ? 12 : 0),
              bottomRight:
                  Radius.circular(messages[index].senderId == 00 ? 0 : 12),
            ),
            color: messages[index].senderId != 00
                ? Theme.of(context).primaryColorLight
                : Colors.grey[200]),
        child: Text(messages[index].message, style: TextStyle(color: color)));
  }
}
