import 'package:flutter/material.dart';
import 'package:messaging_app/database/flutterfire.dart';
import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/models/Conversation.dart';
import 'package:messaging_app/widgets/conversation_tile.dart';

import 'landing_screen.dart';
import 'new_conversation.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// The screen where you can see all the conversations
class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchConvo = new TextEditingController();

  List<Conversation> conversations = dummyConversations;
  int bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        leading: Container(
          alignment: Alignment.center,
          // color: Colors.yellow, // To see boundaries
          child: IconButton(
            icon: Icon(Icons.person, color: Theme.of(context).primaryColorLight),
            onPressed: () {
              signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LandingScreen()));
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).primaryColorLight),
            onPressed: () {
              // Create New Conversation
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewConversationScreen()));
            },
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "sent",
              style: TextStyle(fontFamily: "Barlow", color: Theme.of(context).primaryColorLight),
            ),
            Text("ence", style: TextStyle(fontFamily: "Barlow", color: Theme.of(context).primaryColorDark)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search button
          Container(
            height: 50.0,
            margin: EdgeInsets.symmetric(vertical: 4.0),
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: MediaQuery.of(context).size.width * 0.08),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColorLight),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                controller: _searchConvo,
                style: TextStyle(color: Theme.of(context).primaryColorLight),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Conversation",
                  hintStyle: TextStyle(color: Theme.of(context).primaryColorLight),
                  icon: Icon(Icons.search, color: Theme.of(context).primaryColorLight),
                ),
              ),
            ),
          ),
          // List of Conversations
          Expanded(
            // To change to Stream Builder once convos work
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (builderContext, i) => ConversationTile(conversations[i].getLatestMessage()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColorLight,
        selectedIconTheme: IconThemeData(size: 32.0),
        unselectedItemColor: Theme.of(context).primaryColorDark,
        unselectedIconTheme: IconThemeData(size: 20.0),
        currentIndex: bottomNavIndex,
        onTap: (value) => setState(() => bottomNavIndex = value),
        items: [
          BottomNavigationBarItem(label: "Conversations", icon: Icon(Icons.chat_bubble)),
          BottomNavigationBarItem(label: "Friends", icon: Icon(Icons.group)),
        ],
      ),
    );
  }
}
