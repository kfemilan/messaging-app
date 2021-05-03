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
                          builder: (context) => ConversationScreen()));
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
              } else {
                showErrorDialog();
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
                              return selected.isEmpty
                                  ? Text(
                                      'Select Users...',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(5),
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FittedBox(
                                            child: Stack(
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
                                                      backgroundColor: Theme.of(
                                                              context)
                                                          .primaryColorLight,
                                                      heroTag: selected[i].id,
                                                      child: Icon(Icons.close,
                                                          size: 15,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor),
                                                      onPressed: () {
                                                        removeFromSelected(i);
                                                      }),
                                                )
                                              ],
                                            ),
                                          ),
                                          FittedBox(
                                            child: Text(
                                                selected[i].name.split(" ")[0],
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          )
                                        ],
                                      ),
                                    );
                            },
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Theme.of(context).primaryColorLight,
                                      width: 2))),
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
                                  return Container(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                          child: Text(document['name'][0]
                                              .toString()
                                              .toUpperCase())),
                                      title: Text(document['name'],
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark)),
                                      selected: (selected.firstWhere(
                                                  (sel) => sel.id == document.id,
                                                  orElse: () => null) ==
                                              null)
                                          ? false
                                          : true,
                                      selectedTileColor:
                                          Theme.of(context).primaryColorLight,
                                      onTap: () {
                                        Account temp = new Account(
                                            id: document.id,
                                            name: document['name'],
                                            email: document['email']);
                                        var contain = selected.where(
                                            (element) => element.id == temp.id);
                                        if (contain.isEmpty) {
                                          addToSelected(temp);
                                        } else {
                                          var i = selected.indexWhere((element) =>
                                              element.id == document.id);
                                          removeFromSelected(i);
                                        }
                                      },
                                    ),
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

  removeFromSelected(i) {
    setState(() {
      selected.removeWhere((element) => element.id == selected[i].id);
    });
  }

  addToSelected(temp) {
    setState(() {
      selected.add(temp);
      print(temp.name);
      print(selected);
    });
  }

  showErrorDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No User Selected!', style: Theme.of(context).textTheme.headline3),
          content: Text('Please select a user to start a conversation.'),
          actions: [
            TextButton(child: Text('Ok'), onPressed: (){Navigator.pop(context);},)
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        );
      }
    );
  }

}
