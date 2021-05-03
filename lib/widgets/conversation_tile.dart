import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:messaging_app/models/Message.dart';
import 'package:messaging_app/screens/conversation_screen.dart';
import 'package:messaging_app/database/flutterfire.dart';
import 'package:messaging_app/widgets/alert_dialogs.dart';

class ConversationTile extends StatefulWidget {
  const ConversationTile(this.conversationId, this.name, {Key key}) : super(key: key);
  final String name, conversationId;
  @override
  _ConversationTileState createState() => _ConversationTileState();
}

class _ConversationTileState extends State<ConversationTile> {
  String sender = ""; // To get name of userId
  Message latestMessage = Message(message: "Error retrieving Message", timeSent: DateTime.now(), senderId: "Error");
  String time = "Time"; // Just in case of error
  bool isSeen = false;

  Future<String> _getDMName() async {
    if (widget.name != "") return widget.name;
    try {
      DocumentSnapshot convoSnapshot = await FirebaseFirestore.instance.collection('Conversations').doc(widget.conversationId).get();
      List<dynamic> userIds = convoSnapshot.data()['people'];
      return (userIds[0] == FirebaseAuth.instance.currentUser.uid ? await getName(userIds[1]) : await getName(userIds[0]));
    } on Exception catch (e) {
      print(e.toString());
      return "Error getting name";
    }
  }

  Future<Message> _getLatestMessage() async {
    try {
      QuerySnapshot messages = await FirebaseFirestore.instance
          .collection('Conversations')
          .doc('${widget.conversationId}')
          .collection('Messages')
          .orderBy('timeSent', descending: true)
          .get();
      if (messages.size == 0) {
        // If no messages yet
        var date =
            (await FirebaseFirestore.instance.collection('Conversations').doc('${widget.conversationId}').get()).data()['latestMessageTime'].toDate();
        return Message(
          message: "Start a conversation!",
          senderId: "",
          timeSent: date,
        );
      }
      Map<String, dynamic> retrievedMessage = messages.docs.elementAt(0).data();
      return Message(
        message: retrievedMessage['label'] == "text" ? retrievedMessage['message'] : "Sent an image.",
        senderId: await getName(retrievedMessage['senderID']),
        timeSent: retrievedMessage['timeSent'].toDate(),
      );
    } on Exception catch (e) {
      print(e.toString());
      return Message(message: "Error retrieving Message", timeSent: DateTime.now(), senderId: "Error");
    }
  }

  Future<bool> _getSeen() async {
    try {
      DocumentSnapshot convoSnapshot = await FirebaseFirestore.instance.collection('Conversations').doc(widget.conversationId).get();
      print("hayst");
      // print(convoSnapshot.data()['lastSeen'][0]);
      // DateTime lastSeen = convoSnapshot.data()['lastSeen'][FirebaseAuth.instance.currentUser.uid];
      // print(lastSeen);
      return false;
    } on Exception catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<List<dynamic>> _retrieveData() async {
    try {
      String dmName = await _getDMName(); // Name of Convo is at index 0
      Message message = await _getLatestMessage(); // Message is at index 1
      bool hasSeen = await _getSeen();
      return [dmName, message, hasSeen];
    } on Exception catch (e) {
      print(e.toString());
    }
    return ["", Message(message: "Error retrieving Message", timeSent: DateTime.now(), senderId: "Error"), false];
  }

  @override
  Widget build(BuildContext context) {
    DateTime messageDay = latestMessage.timeSent, today = DateTime.now(), lastWeek = DateTime.now().subtract(Duration(days: 7));
    return FutureBuilder(
      future: _retrieveData(),
      builder: (context, snapshot) {
        // Name of Convo is at index 0
        // Message is at index 1
        // Seen is at index 2
        if (!snapshot.hasData) return SizedBox(height: 0, width: 0);
        // Once latest message is retrieved
        latestMessage = snapshot.data[1];
        isSeen = snapshot.data[2];

        if (today.day == messageDay.day && today.month == messageDay.month && today.year == messageDay.year)
          time = DateFormat.jm().format(latestMessage.timeSent); // Same day, just
        else if (messageDay.compareTo(lastWeek) >= 0)
          time = DateFormat.E().format(latestMessage.timeSent); // WeekdayAbbr e.g. Fri
        else
          time = DateFormat.MMMd().format(latestMessage.timeSent); // MonthAbbr Date e.g. Mar 1

        return Dismissible(
          key: Key(widget.conversationId.toString()),
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
              bool delSuccess = false;
              if (dismiss) delSuccess = await leaveConversation(widget.conversationId);
              if (delSuccess) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Left conversation.')));
            } else {
              // More
              print("More");
              bool edit = await showDialog<bool>(
                  context: context, builder: (BuildContext context) => EditConversationAlertDialog(snapshot.data[0], widget.conversationId));
            }
            return dismiss;
          },
          child: InkWell(
            onTap: () {
              updateSeenTimeStamp(widget.conversationId);
              return Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ConversationScreen(conversationID: widget.conversationId, name: snapshot.data[0])));
            },
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
                      backgroundImage: AssetImage('assets/defaultpp.jpg'),
                    ),
                  ),
                  // Message Preview
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${snapshot.data[0]}", // Convo Name
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                latestMessage.senderId + (latestMessage.senderId == "" ? "" : ": ") + latestMessage.message,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: isSeen ? Colors.grey : Theme.of(context).primaryColorLight),
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
