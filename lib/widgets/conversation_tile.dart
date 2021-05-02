import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/models/Message.dart';
import 'package:messaging_app/screens/conversation_screen.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile(this.message, {Key key}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    String time = "Time"; // Just in case of error
    DateTime messageDay = message.timeSent, today = DateTime.now(), lastWeek = DateTime.now().subtract(Duration(days: 7));

    if (today.day == messageDay.day && today.month == messageDay.month && today.year == messageDay.year)
      time = DateFormat.jm().format(message.timeSent); // Same day, just time
    else if (messageDay.compareTo(lastWeek) >= 0)
      time = DateFormat.E().format(message.timeSent); // WeekdayAbbr e.g. Fri
    else
      time = DateFormat.MMMd().format(message.timeSent); // MonthAbbr Date e.g. Mar 1

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen())),
      child: Container(
        height: 75.0,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        margin: EdgeInsets.symmetric(vertical: 1.0),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Container(
              height: 60.0,
              width: 60.0,
              margin: EdgeInsets.only(left: 10.0, right: 15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColorLight),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                // color: Colors.red,
              ),
              child: Image(
                width: 60,
                height: 60,
                image: NetworkImage(kDefaultProfilePicture),
                color: Theme.of(context).primaryColorLight,
              ),
            ),

            // Center Text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "2Change2Sender:",
                    style: TextStyle(color: Colors.black),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${this.message.message}", style: TextStyle(color: Colors.black)),
                      Text("| $time", style: TextStyle(color: Colors.black)),
                    ],
                  ), // Timestamp
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
