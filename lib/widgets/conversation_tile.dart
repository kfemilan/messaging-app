import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/models/Message.dart';
import 'package:messaging_app/screens/conversation_screen.dart';

import 'dart:math'; // for RNG

class ConversationTile extends StatelessWidget {
  const ConversationTile(this.conversationId, this.name, this.message, {Key key}) : super(key: key);
  final String name, conversationId;
  final Message message;

  @override
  Widget build(BuildContext context) {
    String sender = "";
    String time = "Time"; // Just in case of error
    DateTime messageDay = message.timeSent, today = DateTime.now(), lastWeek = DateTime.now().subtract(Duration(days: 7));

    if (today.day == messageDay.day && today.month == messageDay.month && today.year == messageDay.year)
      time = DateFormat.jm().format(message.timeSent); // Same day, just time
    else if (messageDay.compareTo(lastWeek) >= 0)
      time = DateFormat.E().format(message.timeSent); // WeekdayAbbr e.g. Fri
    else
      time = DateFormat.MMMd().format(message.timeSent); // MonthAbbr Date e.g. Mar 1

    // to remove later
    var rng = Random();
    sender = ["Matthew", "Mark", "Luke", "John", "Acts"][rng.nextInt(5)];

    return Dismissible(
      key: Key(message.toString()),
      background: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 20.0),
        child: Icon(Icons.more, color: Theme.of(context).primaryColorLight, size: 30),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(right: 20.0),
        child: Icon(Icons.delete, color: Theme.of(context).primaryColorLight, size: 30),
      ),
      confirmDismiss: (direction) async {
        bool dismiss = false;
        if (direction == DismissDirection.endToStart) {
          // Delete
          dismiss = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                title: Text("Delete Conversation?", style: Theme.of(context).textTheme.bodyText1),
                actions: <Widget>[
                  TextButton(
                    child: Text("No", style: TextStyle(color: Colors.grey)),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).primaryColorLight),
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: primaryLight),
                      child: Text("Yes", style: TextStyle(color: Colors.white)),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          // More
          print("More");
        }
        return dismiss;
      },
      child: InkWell(
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
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(kDefaultProfilePicture),
                ),
              ),
              // Center Text
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("$sender: ${this.message.message}", style: TextStyle(color: Colors.grey)),
                        Text("$time", style: TextStyle(color: Colors.black)),
                      ],
                    ), // Timestamp
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
