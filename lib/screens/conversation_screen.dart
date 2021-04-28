import 'package:flutter/material.dart';

class ConversationScreen extends StatelessWidget {
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
                IconButton(icon: Icon(Icons.image), onPressed: () {}),
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
