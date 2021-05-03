import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/models/Message.dart';
import 'package:messaging_app/screens/conversation_screen.dart';
import 'package:messaging_app/database/flutterfire.dart';

import 'dart:math'; // for RNG, 2 remove later

class ConversationTile extends StatefulWidget {
  const ConversationTile(this.conversationId, this.name, this.message, {Key key}) : super(key: key);
  final String name, conversationId;
  final Message message;
  @override
  _ConversationTileState createState() => _ConversationTileState();
}

class _ConversationTileState extends State<ConversationTile> {
  Future<String> _getDMName() async {
    if (widget.name != "") return widget.name;
    DocumentSnapshot convoSnapshot = await FirebaseFirestore.instance.collection('Conversations').doc(widget.conversationId).get();
    List<dynamic> userIds = convoSnapshot.data()['people'];
    return (userIds[0] == FirebaseAuth.instance.currentUser.uid ? await getName(userIds[1]) : await getName(userIds[0]));
  }

  @override
  Widget build(BuildContext context) {
    String sender = ""; // To get name of userId
    String time = "Time"; // Just in case of error
    DateTime messageDay = widget.message.timeSent, today = DateTime.now(), lastWeek = DateTime.now().subtract(Duration(days: 7));

    if (today.day == messageDay.day && today.month == messageDay.month && today.year == messageDay.year)
      time = DateFormat.jm().format(widget.message.timeSent); // Same day, just time
    else if (messageDay.compareTo(lastWeek) >= 0)
      time = DateFormat.E().format(widget.message.timeSent); // WeekdayAbbr e.g. Fri
    else
      time = DateFormat.MMMd().format(widget.message.timeSent); // MonthAbbr Date e.g. Mar 1

    // to remove later
    var rng = Random();
    sender = ["Matthew", "Mark", "Luke", "John", "Acts"][rng.nextInt(5)];

    return FutureBuilder(
      future: _getDMName(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox(height: 0, width: 0);
        return Dismissible(
          key: Key(widget.message.toString()),
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
                builder: (BuildContext context) => DeleteConversationAlertDialog(),
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
                  // Message Preview
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${snapshot.data}",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "$sender: ${this.widget.message.message}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Text("$time", style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Separated since it was getting a bit too unreadable
class DeleteConversationAlertDialog extends StatelessWidget {
  const DeleteConversationAlertDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}
