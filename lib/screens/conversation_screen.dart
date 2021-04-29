import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ConversationScreen extends StatefulWidget {
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
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
              Text("Jules Russel", style: TextStyle(fontSize: 18.0)),
              Text("Seen 1 hour ago", style: TextStyle(fontSize: 12.0)),
            ],
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.access_alarm_outlined), onPressed: () {})
          ],
        ),
        body: Column(
          children: [
            Expanded(child: Center(child: Text("List view here!"))),
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
