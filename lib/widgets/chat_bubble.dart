import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/database/flutterfire.dart';
import 'package:messaging_app/models/Message.dart';

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
                if (!snapshot.hasData) return SizedBox(height: 0, width: 0);
                return Text(snapshot.data,
                    style: TextStyle(color: Colors.black, fontSize: 12.0));
              }),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft:
                    Radius.circular(message.senderId == userID ? 12 : 0),
                bottomRight:
                    Radius.circular(message.senderId == userID ? 0 : 12),
              ),
              color: message.senderId != userID
                  ? Theme.of(context).primaryColorLight
                  : Colors.grey[300]),
          child: message.label == "text"
              ? Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  child: Text(message.message, style: TextStyle(color: color)))
              : Container(
                  constraints: BoxConstraints(
                      minHeight: 100.0,
                      minWidth: 100.0,
                      maxHeight: 200.0,
                      maxWidth: 200.0),
                  child: Image(
                      image: NetworkImage(message.message), fit: BoxFit.cover)),
        ),
      ],
    );
  }
}
