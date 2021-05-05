import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:messaging_app/models/Account.dart';
import 'package:messaging_app/models/Message.dart';
import 'package:messaging_app/screens/conversation_screen.dart';
import 'package:messaging_app/database/flutterfire.dart';
import 'package:messaging_app/widgets/alert_dialogs.dart';

class ConversationTile extends StatefulWidget {
  const ConversationTile(this.conversationId, this.name, this.searchFilter, {Key key}) : super(key: key);
  final String name, conversationId, searchFilter;
  @override
  _ConversationTileState createState() => _ConversationTileState();
}

class _ConversationTileState extends State<ConversationTile> {
  String sender = ""; // To get name of userId
  Message latestMessage = Message(message: "Error retrieving Message", timeSent: DateTime.now(), senderId: "Error");
  String time = "Time"; // Just in case of error
  bool isSeen = false;
  final String currentUserId = FirebaseAuth.instance.currentUser.uid;

  Future<String> _getConvoName() async {
    if (widget.name != "") return widget.name;
    try {
      DocumentSnapshot convoSnapshot = await FirebaseFirestore.instance.collection('Conversations').doc(widget.conversationId).get();
      List<dynamic> userIds = convoSnapshot.data()['people'];
      return (userIds[0] == currentUserId ? await getName(userIds[1]) : await getName(userIds[0]));
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
        DocumentSnapshot convoSnapshot = await FirebaseFirestore.instance.collection('Conversations').doc(widget.conversationId).get();
        DateTime date = (convoSnapshot.data()['latestMessageTime']).toDate();
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

  Future<bool> _getIsSeen(DateTime latestMessageTime) async {
    try {
      DocumentSnapshot convoSnapshot = await FirebaseFirestore.instance.collection('Conversations').doc(widget.conversationId).get();
      DateTime userLastAccessed = (convoSnapshot.data()['lastSeen'][currentUserId]).toDate();
      if (userLastAccessed.compareTo(latestMessageTime) >= 0) return true;
      return false;
    } on Exception catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<dynamic> _getConvoImage() async {
    if (widget.name != "") return AssetImage('assets/defaultpp.jpg');
    try {
      DocumentSnapshot convoSnapshot = await FirebaseFirestore.instance.collection('Conversations').doc(widget.conversationId).get();
      List<dynamic> userIds = convoSnapshot.data()['people'];
      String userToGetImg = userIds[0] == currentUserId ? userIds[1] : userIds[0];
      Account user = await getAccount(userToGetImg);
      return user.profilePic.isEmpty ? AssetImage('assets/defaultpp.jpg') : CachedNetworkImageProvider(user.profilePic);
    } on Exception catch (e) {
      print(e.toString());
      return AssetImage('assets/defaultpp.jpg');
    }
  }

  Future<Map<String, dynamic>> _retrieveData() async {
    try {
      String dmName = await _getConvoName();
      Message message = await _getLatestMessage();
      bool hasSeen = await _getIsSeen(message.timeSent);
      dynamic image = await _getConvoImage();
      return {
        'convoName': dmName,
        'message': message,
        'isSeen': hasSeen,
        'convoImage': image,
      };
    } on Exception catch (e) {
      print(e.toString());
    }
    return {
      'convoName': "Error",
      'message': Message(message: "Error retrieving Message", timeSent: DateTime.now(), senderId: "Error"),
      'isSeen': false,
      'convoImage': AssetImage('assets/defaultpp.jpg'),
    };
  }

  @override
  Widget build(BuildContext context) {
    DateTime messageDay = latestMessage.timeSent, today = DateTime.now(), lastWeek = DateTime.now().subtract(Duration(days: 7));
    return FutureBuilder(
      future: _retrieveData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _buildConvoTile(context, snapshot, false);
        // Once latest message is retrieved
        if (!snapshot.data['convoName'].toLowerCase().contains(widget.searchFilter)) return SizedBox(height: 0, width: 0);
        latestMessage = snapshot.data['message'];
        isSeen = snapshot.data['isSeen'];

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
            padding: EdgeInsets.only(left: 20.0),
            color: Theme.of(context).primaryColorDark,
            child: Icon(Icons.more, color: Theme.of(context).primaryColorLight, size: 30),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20.0),
            color: Theme.of(context).primaryColorDark,
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
              if (delSuccess)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.2,
                      right: MediaQuery.of(context).size.width * 0.2,
                      bottom: MediaQuery.of(context).size.height * 0.5,
                    ),
                    content: Text("Left conversation.", textAlign: TextAlign.center),
                  ),
                );
            } else {
              // More
              bool editSuccess = await showDialog<bool>(
                  context: context, builder: (BuildContext context) => EditConversationAlertDialog(snapshot.data[0], widget.conversationId));
              if (editSuccess)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.2,
                      right: MediaQuery.of(context).size.width * 0.2,
                      bottom: MediaQuery.of(context).size.height * 0.5,
                    ),
                    content: Text("Conversation edited!", textAlign: TextAlign.center),
                  ),
                );
            }
            return dismiss;
          },
          child: InkWell(
            onTap: () {
              updateSeenTimeStamp(widget.conversationId);
              return Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConversationScreen(
                            conversationID: widget.conversationId,
                            name: snapshot.data['convoName'],
                          ))).then(
                (value) => updateSeenTimeStamp(widget.conversationId),
              );
            },
            child: _buildConvoTile(context, snapshot, true),
          ),
        );
      },
    );
  }

  Container _buildConvoTile(BuildContext context, AsyncSnapshot snapshot, bool loaded) {
    return Container(
      height: 75.0,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.symmetric(vertical: 1.0),
      alignment: Alignment.center,
      // color: loaded ? Colors.white : Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: CircleAvatar(
              radius: 30.0,
              backgroundColor: loaded ? Colors.white : Theme.of(context).primaryColorLight,
              backgroundImage: loaded ? AssetImage('assets/defaultpp.jpg') : null,
              foregroundImage: loaded ? snapshot.data['convoImage'] : null,
              child: loaded ? SizedBox(height: 0, width: 0) : CircularProgressIndicator(),
            ),
          ),
          // Message Preview
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loaded ? "${snapshot.data['convoName']}" : "", // Convo Name
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        loaded ? (latestMessage.senderId + (latestMessage.senderId == "" ? "" : ": ") + latestMessage.message) : "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: isSeen ? Colors.grey : Theme.of(context).primaryColorLight),
                      ),
                    ),
                    Text(loaded ? "$time" : "", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
