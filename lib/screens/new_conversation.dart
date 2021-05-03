import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/database/flutterfire.dart';
import 'package:messaging_app/models/Account.dart';
import 'package:messaging_app/screens/conversation_screen.dart';

import 'confirm_create_screen.dart';

class NewConversationScreen extends StatefulWidget {
  NewConversationScreen({Key key}) : super(key: key);

  @override
  _NewConversationScreenState createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> {
  TextEditingController _name = new TextEditingController();
  List<Account> selected = [];
  String userID2, name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text('New Conversation'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () async {
              if (selected.length == 1) {
                int successful = await createConversation(selected, "");
                print(successful);
                if (successful == 1) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConversationScreen(
                                  name: name,
                                  people: [
                                    userID2,
                                    FirebaseAuth.instance.currentUser.uid
                                  ])));
                } else if (successful == -1) {
                  // Navigate to Existing Chat screen
                  // For now Pop lang sa
                  Navigator.pop(context);
                }
              } else if (selected.length > 1) {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ConfirmCreateScreen(selected: selected)))
                    .then((value) => setState(() {}));
              }
            },
          )
        ],
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                // Search Bar
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height * 0.1,
                color: Theme.of(context).primaryColorLight,
                alignment: Alignment.center,
                child: TextField(
                  style: Theme.of(context).textTheme.bodyText2,
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).primaryColor,
                    hintText: 'Search',
                    hintStyle: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Theme.of(context).accentColor,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
              ),
              Expanded(
                // The Rest
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).accentColor,
                    child: Column(
                      children: [
                        Container(
                          // List of Selected users
                          height: MediaQuery.of(context).size.height * 0.12,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selected.length,
                            itemBuilder: (context, i) {
                              return selected.length <= 0
                                  ? Center(
                                      child: Text(
                                      'Select Users...',
                                      style: TextStyle(color: Colors.black),
                                    ))
                                  : Container(
                                      padding: EdgeInsets.all(5),
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.07,
                                                child: Text(selected[i]
                                                    .name[0]
                                                    .toUpperCase()),
                                              ),
                                              Container(
                                                width: 20,
                                                height: 20,
                                                child: FloatingActionButton(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColorLight,
                                                    heroTag: selected[i].id,
                                                    child: Icon(Icons.close,
                                                        size: 15,
                                                        color: Theme.of(context)
                                                            .accentColor),
                                                    onPressed: () {
                                                      setState(() {
                                                        selected.removeWhere(
                                                            (element) =>
                                                                element.id ==
                                                                selected[i].id);
                                                      });
                                                    }),
                                              )
                                            ],
                                          ),
                                          Text(selected[i].name.split(" ")[0],
                                              style: TextStyle(
                                                  color: Colors.black))
                                        ],
                                      ),
                                    );
                            },
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Theme.of(context).primaryColorDark,
                                      width: 1))),
                        ),
                        Expanded(
                          // List of Users
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Users')
                                .orderBy('name', descending: false)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return ListView(
                                children: snapshot.data.docs.map((document) {
                                  String uID =
                                      FirebaseAuth.instance.currentUser.uid;
                                  if (uID == document.id) {
                                    return SizedBox();
                                  }
                                  return ListTile(
                                    leading: CircleAvatar(
                                        child: Text(document['name'][0]
                                            .toString()
                                            .toUpperCase())),
                                    title: Text(document['name']),
                                    onTap: () {
                                      userID2 = document.id;
                                      name = document['name'];

                                      Account temp = new Account(
                                          id: document.id,
                                          name: document['name'],
                                          email: document['email']);
                                      var contain = selected.where(
                                          (element) => element.id == temp.id);
                                      if (contain.isEmpty) {
                                        setState(() {
                                          selected.add(temp);
                                          print(temp.name);
                                          print(selected);
                                        });
                                      }
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
