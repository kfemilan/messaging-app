import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging_app/database/flutterfire.dart';
import 'package:messaging_app/models/Account.dart';
import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/models/Message.dart';
import 'package:messaging_app/widgets/chat_bubble.dart';
import 'package:path/path.dart';

class ConversationScreen extends StatefulWidget {
  final conversationID, name;

  const ConversationScreen({Key key, this.conversationID, this.name})
      : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<Message> _messages;
  TextEditingController _message = new TextEditingController();
  File _image;

  String imageUrl = kDefaultProfilePicture;
  String dataSent = "text"; // Either text or image
  final picker = ImagePicker();
  final userID = FirebaseAuth.instance.currentUser.uid;

  Future uploadImageToFirebase() async {
    final imgName = basename(_image.path);
    final _firebaseStorage = firebase_storage.FirebaseStorage.instance;
    if (_image != null) {
      //Upload to Firebase
      var snapshot = await _firebaseStorage
          .ref()
          .child('$userID/$imgName')
          .putFile(_image);
      // Get image from firebase
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      print('No Image Path Received');
    }
  }

  Future getImage(String option) async {
    final pickedFile = await picker.getImage(
        source: option == "Camera" ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        dataSent = "image";
      }
    });
  }

  Future<List> getMembers() async {
    final conRef = await FirebaseFirestore.instance
        .collection('Conversations')
        .doc(widget.conversationID)
        .get();
    return conRef.data()['people'];
  }

  Future<String> getTimeDifference() async {
    final members = await getMembers();
    final gg = await FirebaseFirestore.instance
        .collection('Conversations')
        .doc(widget.conversationID)
        .get();
    DateTime latestSeenTime;
    members.removeWhere((id) => id == userID);
    latestSeenTime = gg.data()['lastSeen'][members[0]].toDate();
    for (int i = 1; i < members.length; i++) {
      if (latestSeenTime.isBefore(gg.data()['lastSeen'][members[i]].toDate())) {
        print("YES");
        latestSeenTime = gg.data()['lastSeen'][members[i]].toDate();
      }
    }
    print(latestSeenTime);
    return DateTime.now().difference(latestSeenTime).inSeconds.toString();
  }

  @override
  Widget build(BuildContext context) {
    void _sendMessage() async {
      FocusScope.of(context).unfocus();
      if (dataSent == "image") {
        await uploadImageToFirebase();
        _message.text = imageUrl;
      }

      FirebaseFirestore.instance
          .collection('Conversations')
          .doc(widget.conversationID)
          .collection('Messages')
          .add({
        'senderID': userID,
        'message': _message.text,
        'label': dataSent,
        'timeSent': DateTime.now(),
      });
      FirebaseFirestore.instance
          .collection('Conversations')
          .doc(widget.conversationID)
          .update({
        'latestMessageTime': DateTime.now(),
      });

      _message.clear();
      dataSent = "text";
    }

    String _getTimeLabel(int seconds) {
      // Seconds
      if (seconds > 60) {
        int time = seconds ~/ 60;
        // Minutes
        if (time > 60) {
          time ~/= 60;
          // Hours and Days
          return time > 24
              ? "${(time ~/ 24).toString()} day(s)"
              : "${time.toString()} hour(s)";
        } else
          return "${time.toString()} minute(s)";
      } else
        return "${seconds.toString()} second(s)";
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Column(
            children: [
              Text(widget.name, style: Theme.of(context).textTheme.headline6),
              FutureBuilder(
                  future: getTimeDifference(),
                  builder: (_, snapshot) {
                    return !snapshot.hasData
                        ? SizedBox()
                        : Text(
                            "Seen ${_getTimeLabel(int.parse(snapshot.data))} ago",
                            style: Theme.of(context).textTheme.headline6);
                  })
            ],
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  List people = await getMembers();
                  print(people);
                  showMemberDialog(context, people);
                },
                icon: Icon(
                  Icons.more_horiz,
                ))
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Conversations')
                      .doc(widget.conversationID)
                      .collection('Messages')
                      .orderBy('timeSent', descending: true)
                      .snapshots(),
                  builder: (_, chatSnapshot) {
                    if (chatSnapshot.connectionState !=
                        ConnectionState.waiting) {
                      _messages = [];
                      // Snapshot to List
                      chatSnapshot.data.docs
                          .map((QueryDocumentSnapshot document) {
                        return _messages.add(Message(
                            senderId: document['senderID'],
                            label: document['label'],
                            timeSent: document['timeSent'].toDate(),
                            message: document['message']));
                      }).toList();
                      _messages.reversed.toList();
                      return ListView.builder(
                          reverse: true,
                          itemCount: chatSnapshot.data.size,
                          itemBuilder: (_, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment:
                                  _messages[index].senderId == userID
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                if (_messages[index].senderId != userID)
                                  Image(
                                      width: 35,
                                      height: 35,
                                      image:
                                          NetworkImage(kDefaultProfilePicture)),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 5.0),
                                  child: ChatBubble(
                                      message: _messages[index],
                                      color: _messages[index].senderId != userID
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ],
                            );
                          });
                    } else
                      return Center(child: CircularProgressIndicator());
                  }),
            )),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    color: Theme.of(context).primaryColorLight,
                    icon: Icon(Icons.camera_alt),
                    onPressed: () => getImage("Camera"),
                  ),
                  IconButton(
                    color: Theme.of(context).primaryColorLight,
                    icon: Icon(Icons.image),
                    onPressed: () => getImage("Gallery"),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      alignment: Alignment.centerLeft,
                      height: dataSent == "image" ? 100.0 : null,
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColorLight),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: dataSent == "text"
                          ? TextFormField(
                              controller: _message,
                              style: TextStyle(fontSize: 13.0),
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      top: 12.0, right: 12.0, bottom: 12.0),
                                  border: InputBorder.none,
                                  hintText: "Enter your message...",
                                  hintStyle: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight)),
                            )
                          : Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                      width: 80.0,
                                      height: 80.0,
                                      child: Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  child: FloatingActionButton(
                                      backgroundColor:
                                          Theme.of(context).primaryColorLight,
                                      child: Icon(Icons.close,
                                          size: 15,
                                          color: Theme.of(context).accentColor),
                                      onPressed: () {
                                        setState(() {
                                          dataSent = "text";
                                        });
                                      }),
                                )
                              ],
                            ),
                    ),
                  ),
                  IconButton(
                      color: Theme.of(context).primaryColorLight,
                      icon: Icon(Icons.send),
                      onPressed: _sendMessage),
                ],
              ),
            ),
          ],
        ));
  }

  showMemberDialog(context, people) async {
    List<Account> accountList = [];
    for (var x = 0; x < people.length; x++) {
      Account temp = await getAccount(people[x]);
      accountList.add(temp);
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Members',
            style: Theme.of(context).textTheme.headline3,
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.6,
            child: ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: CircleAvatar(
                      child: Text(accountList[i].name[0].toUpperCase())),
                  title: Text(
                    accountList[i].name,
                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                  ),
                  selectedTileColor: Theme.of(context).primaryColorLight,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        );
      },
    );
  }
}
