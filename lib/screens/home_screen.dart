import 'package:flutter/material.dart';
import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/models/Conversation.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// The screen where you can see all the conversations
class _HomeScreenState extends State<HomeScreen> {
  List<Conversation> conversations = [];
  int bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        leading: Container(
          alignment: Alignment.center,
          // color: Colors.yellow, // To see boundaries
          child: Icon(Icons.person, color: primaryLight),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: primaryLight),
            onPressed: () {},
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "sent",
              style: TextStyle(color: primaryLight),
            ),
            Text("ence", style: TextStyle(color: primaryDark)),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text('Successfully Logged in! ' + (bottomNavIndex == 0 ? 'Private' : 'Group') + ' Conversations'),
          ),
          // To add Conversation Tiles
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryLight,
        selectedIconTheme: IconThemeData(size: 32.0),
        unselectedItemColor: primaryDark,
        unselectedIconTheme: IconThemeData(size: 20.0),
        currentIndex: bottomNavIndex,
        onTap: (value) => setState(() => bottomNavIndex = value),
        items: [
          BottomNavigationBarItem(label: "Private", icon: Icon(Icons.person)),
          BottomNavigationBarItem(label: "Group", icon: Icon(Icons.group)),
        ],
      ),
    );
  }
}
