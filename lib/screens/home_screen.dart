import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:messaging_app/database/flutterfire.dart';
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
  int bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        leading: Container(
          alignment: Alignment.center,
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
            icon: Icon(Icons.message, color: Theme.of(context).primaryColorLight),
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
              child: TextFormField(
                onChanged: (currentStr) {
                  setState(() {
                    // Nothing actually happens here lmao, setState is called just for the rebuild
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Conversations")
                  .where("people", arrayContains: FirebaseAuth.instance.currentUser.uid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                print(FirebaseAuth.instance.currentUser.uid);
                // if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                if (snapshot.connectionState == ConnectionState.waiting) return SizedBox(height: 0, width: 0);
                List mappedDocs = snapshot.data.docs
                    .map((docu) => {
                          'convoId': docu.id,
                          'name': docu.data()['name'],
                          'people': docu.data()['people'],
                          'latestMessageTime': docu.data()['latestMessageTime'].toDate(),
                        })
                    .toList();
                mappedDocs.sort((b, a) => a['latestMessageTime'].compareTo(b['latestMessageTime']));
                print(mappedDocs.isEmpty);
                return mappedDocs.isNotEmpty
                    ? ListView.builder(
                        itemCount: mappedDocs.length,
                        itemBuilder: (BuildContext context, index) {
                          return mappedDocs[index]['name'].toLowerCase().contains(_searchConvo.value.text.toLowerCase())
                              ? ConversationTile(mappedDocs[index]['convoId'], mappedDocs[index]['name'])
                              : SizedBox(width: 0, height: 0);
                        })
                    : Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: EdgeInsets.only(top: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Start a new",
                                style: TextStyle(color: Theme.of(context).primaryColorLight, fontFamily: "Barlow", fontSize: 26.0),
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewConversationScreen())),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      padding: EdgeInsets.only(right: 8.0),
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "conversation!",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Barlow",
                                          fontSize: 26.0,
                                        ),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(Theme.of(context).primaryColorDark),
                                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColorLight),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    margin: EdgeInsets.only(top: 2.0),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Message sent(ence): ${DateFormat.jm().format(DateTime.now())}",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
              },
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: Theme.of(context).primaryColorLight,
      //   selectedIconTheme: IconThemeData(size: 32.0),
      //   unselectedItemColor: Theme.of(context).primaryColorDark,
      //   unselectedIconTheme: IconThemeData(size: 20.0),
      //   currentIndex: bottomNavIndex,
      //   onTap: (value) => setState(() => bottomNavIndex = value),
      //   items: [
      //     BottomNavigationBarItem(label: "Conversations", icon: Icon(Icons.chat_bubble)),
      //     BottomNavigationBarItem(label: "Friends", icon: Icon(Icons.group)),
      //   ],
      // ),
    );
  }
}
