import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/models/Message.dart';

class ConversationScreen extends StatefulWidget {
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<Message> _messages = [
    Message(senderId: 01, message: "Hi!", timeSent: DateTime.now()),
    Message(senderId: 00, message: "Hello!", timeSent: DateTime.now()),
    Message(senderId: 01, message: "How are you?", timeSent: DateTime.now()),
    Message(
        senderId: 00, message: "I'm fine thank you!", timeSent: DateTime.now()),
  ].reversed.toList();
  File _image;
  final picker = ImagePicker();

  Future getImage(String option) async {
    final pickedFile = await picker.getImage(
        source: option == "Camera" ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      if (pickedFile != null) _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
              color: Colors.grey[200],
              child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (_, index) {
                    return Row(
                      mainAxisAlignment: _messages[index].senderId == 00
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: _messages[index].senderId == 00
                          ? [
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(
                                            _messages[index].senderId == 00
                                                ? 12
                                                : 0),
                                        bottomRight: Radius.circular(
                                            _messages[index].senderId == 00
                                                ? 0
                                                : 12),
                                      ),
                                      color: _messages[index].senderId != 00
                                          ? Theme.of(context).primaryColorLight
                                          : Colors.white),
                                  child: Text(_messages[index].message,
                                      style: TextStyle(color: Colors.black))),
                            ]
                          : [
                              Image(
                                  width: 35,
                                  height: 35,
                                  image: NetworkImage(kDefaultProfilePicture)),
                              SizedBox(width: 10.0),
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(
                                            _messages[index].senderId == 00
                                                ? 12
                                                : 0),
                                        bottomRight: Radius.circular(
                                            _messages[index].senderId == 00
                                                ? 0
                                                : 12),
                                      ),
                                      color: _messages[index].senderId != 00
                                          ? Theme.of(context).primaryColorLight
                                          : Colors.white),
                                  child: Text(_messages[index].message,
                                      style: TextStyle(color: Colors.black))),
                            ],
                    );
                  }),
            )),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => getImage("Camera"),
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () => getImage("Gallery"),
                ),
                Expanded(
                  child: TextField(
                      decoration:
                          InputDecoration(labelText: "Enter your message...")),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: () {}),
              ],
            ),
          ],
        ));
  }
}
