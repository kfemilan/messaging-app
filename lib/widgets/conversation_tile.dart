import 'package:flutter/material.dart';
import 'package:messaging_app/models/Message.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile(this.message, {Key key}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 1.0),
      decoration: BoxDecoration(
        // color: Colors.grey,
        border: Border.symmetric(
          horizontal: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile Picture
          Text("SenderName: ${this.message.message}"),
        ],
      ),
    );
  }
}
