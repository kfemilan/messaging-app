import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:messaging_app/database/flutterfire.dart';
import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/models/Conversation.dart';
import 'package:messaging_app/screens/landing_screen.dart';
import 'package:messaging_app/screens/new_conversation.dart';
import 'package:messaging_app/widgets/conversation_tile.dart';

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
              // padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                onChanged: (currentStr) {
                  setState(() {
                    // Nothing actually happens here lmao
                    print("$currentStr | ${_searchConvo.value.text}");
                  });
                },
                controller: _searchConvo,
                style: TextStyle(color: Theme.of(context).primaryColorLight),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Conversation",
                  hintStyle: TextStyle(color: Theme.of(context).primaryColorLight),
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColorLight),
                  // icon: Icon(Icons.search, color: Theme.of(context).primaryColorLight),
                ),
              ),
            ),
          ),
          // List of Conversations
          Expanded(
            // To change to Stream Builder once convos work
            // Ref to
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Conversations")
                  .where("people", arrayContains: FirebaseAuth.instance.currentUser.uid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                print(FirebaseAuth.instance.currentUser.uid);
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return ListView(
                  children: snapshot.data.docs.map((QueryDocumentSnapshot document) {
                    String convoname = document['name'];

                    String hayst = "";
                    // getName(FirebaseAuth.instance.currentUser.uid).then((value) => setState());

                    print("lmao $hayst");
                    List<dynamic> userIds = document['people'];
                    if (userIds.length == 2) {
                      // convoname = (userIds[0] == FirebaseAuth.instance.currentUser.uid ? getNameV2(userIds[0]) : getNameV2(userIds[1]));
                    }

                    return document['name'].toLowerCase().contains(_searchConvo.value.text.toLowerCase())
                        ? ConversationTile(document.id, convoname, dummyMessage)
                        : SizedBox(width: 0, height: 0);
                  }).toList(),
                );
              },
              // return ListView.builder(
              //   itemCount: conversations.length,
              //   itemBuilder: (builderContext, i) => conversations[i].name.toLowerCase().contains(_searchConvo.value.text.toLowerCase())
              //       ? ConversationTile(conversations[i].name, conversations[i].getLatestMessage())
              //       : SizedBox(width: 0, height: 0),
              // );
              // },
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
