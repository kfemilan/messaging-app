import 'package:flutter/material.dart';
import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/models/Message.dart';
import 'package:messaging_app/screens/conversation_screen.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile(this.message, {Key key}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ConversationScreen()));
      },
      child: Container(
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
              child: Image(image: NetworkImage(kDefaultProfilePicture)),
              height: 60.0,
              width: 60.0,
              margin: EdgeInsets.only(left: 20.0, right: 15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                // color: Colors.red,
              ),
            ),
            // Center Text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "2Change2Sender:",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  "${this.message.message} ${this.message.timeSent.toString()}",
                  style: TextStyle(color: Colors.black),
                ), // Timestamp
              ],
            ),
          ],
        ),
      ),
    );
  }
}
