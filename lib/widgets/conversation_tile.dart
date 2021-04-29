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
      decoration: BoxDecoration(border: Border(top: BorderSide(width: 1.0), bottom: BorderSide(width: 1.0))),
      alignment: Alignment.center,
      child: Text("ToChangeToSenderName: ${this.message.message}"),
    );
  }
}
