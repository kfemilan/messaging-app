import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/models/Message.dart';
import 'package:messaging_app/widgets/chat_bubble.dart';
import 'package:path/path.dart';

class ConversationScreen extends StatefulWidget {
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<Message> _messages = [
    Message(senderId: "asd", message: "Hi!", timeSent: DateTime.now()),
    Message(
        senderId: FirebaseAuth.instance.currentUser.uid,
        message: "Hello!",
        timeSent: DateTime.now()),
    Message(senderId: "asd", message: "How are you?", timeSent: DateTime.now()),
    Message(
        senderId: FirebaseAuth.instance.currentUser.uid,
        message: "I'm fine thank you!",
        timeSent: DateTime.now()),
  ].reversed.toList();

  File _image;
  String imageUrl = kDefaultProfilePicture;
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
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        print(imageUrl);
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
        // Temporary
        uploadImageToFirebase();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Column(
            children: [
              Text("Jules Russel",
                  style: Theme.of(context).textTheme.headline6),
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
              child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (_, index) {
                    return Row(
                      mainAxisAlignment: _messages[index].senderId == userID
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (_messages[index].senderId != userID)
                          Image(
                              width: 35,
                              height: 35,
                              image: NetworkImage(kDefaultProfilePicture)),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ChatBubble(
                              messages: _messages,
                              index: index,
                              color: _messages[index].senderId != userID
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    );
                  }),
            )),
            Container(
              child: Row(
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
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColorLight),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: TextFormField(
                        style: TextStyle(fontSize: 13.0),
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(13.0),
                            border: InputBorder.none,
                            hintText: "Enter your message...",
                            hintStyle: TextStyle(
                                color: Theme.of(context).primaryColorLight)),
                      ),
                    ),
                  ),
                  IconButton(
                      color: Theme.of(context).primaryColorLight,
                      icon: Icon(Icons.send),
                      onPressed: () {}),
                ],
              ),
            ),
          ],
        ));
  }
}
