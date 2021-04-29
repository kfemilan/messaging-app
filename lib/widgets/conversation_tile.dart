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
      // decoration: BoxDecoration(
      //   border: Border.symmetric(
      //     horizontal: BorderSide(width: 1.0, color: Theme.of(context).primaryColorDark),
      //   ),
      // ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture
          Container(
            height: 60.0,
            width: 60.0,
            margin: EdgeInsets.only(left: 20.0, right: 15.0),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              // color: Colors.red,
            ),
          ),
          // Center Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("2Change2Sender:"),
              Text("${this.message.message} ${this.message.timeSent.toString()}"), // Timestamp
            ],
          ),
        ],
      ),
    );
  }
}
