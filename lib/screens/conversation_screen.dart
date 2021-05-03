import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/models/Message.dart';
import 'package:messaging_app/widgets/chat_bubble.dart';
import 'package:path/path.dart';

class ConversationScreen extends StatefulWidget {
  final conversationID, name, people;

  const ConversationScreen(
      {Key key, this.conversationID, this.name, this.people})
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

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Column(
            children: [
              Text(widget.name, style: Theme.of(context).textTheme.headline6),
              Text("Seen 1 hour ago",
                  style: Theme.of(context).textTheme.headline6),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Image.network(kDefaultProfilePicture),
            )
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
                      .doc('${widget.conversationID}')
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
                                      messages: _messages,
                                      index: index,
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
}
