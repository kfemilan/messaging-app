import 'package:flutter/material.dart';
import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/models/Conversation.dart';
import 'package:messaging_app/widgets/conversation_tile.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// The screen where you can see all the conversations
class _HomeScreenState extends State<HomeScreen> {
  List<Conversation> conversations = dummyConversations;
  int bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        leading: Container(
          alignment: Alignment.center,
          // color: Colors.yellow, // To see boundaries
          child: IconButton(
            icon: Icon(Icons.person, color: Theme.of(context).primaryColor),
            onPressed: () {
              // Logout functionality
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
            onPressed: () {
              // New Conversation
            },
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "sent",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Text("ence", style: TextStyle(color: Theme.of(context).primaryColorDark)),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 50.0,
            margin: EdgeInsets.symmetric(vertical: 6.0),
            color: Colors.yellow,
            alignment: Alignment.center,
            child: TextFormField(
              decoration: InputDecoration(icon: Icon(Icons.search)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (builderContext, i) => ConversationTile(conversations[i].getLatestMessage()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
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
