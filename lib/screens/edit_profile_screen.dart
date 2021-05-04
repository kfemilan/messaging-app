import 'package:flutter/material.dart';

import 'package:messaging_app/database/flutterfire.dart';
import 'package:messaging_app/models/Account.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen(this.userId, {Key key}) : super(key: key);
  final String userId;
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  Account original = Account();

  bool accountEdited() {
    if (!(_usernameController.text == original.name)) return true;
    // if (!(_usernameController.text == original.name && _emailController.text == original.email)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text("Edit Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (!accountEdited()) {
                return ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.2,
                      right: MediaQuery.of(context).size.width * 0.2,
                      bottom: MediaQuery.of(context).size.height * 0.5,
                    ),
                    content: Text("There are no changes to the account.", textAlign: TextAlign.center),
                  ),
                );
              }
              bool success = await updateAccount(Account(id: widget.userId, name: _usernameController.text, email: _emailController.text));
              return ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.2,
                    right: MediaQuery.of(context).size.width * 0.2,
                    bottom: MediaQuery.of(context).size.height * 0.5,
                  ),
                  content: Text(success ? "Account updated successfully!" : "Oops, something bad happened! Better luck next time.",
                      textAlign: TextAlign.center),
                ),
              );
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: getAccount(widget.userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return SizedBox(height: 0, width: 0);

            original.name = snapshot.data.name;
            original.email = snapshot.data.email;
            return Container(
              constraints: BoxConstraints.expand(),
              alignment: Alignment.center,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.06,
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                ),
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    maxRadius: MediaQuery.of(context).size.width * 0.3,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
                  TextFormField(
                    controller: _usernameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: original.name,
                      labelStyle: TextStyle(color: Colors.black, fontSize: 26.0, decorationColor: Colors.red),
                      hintText: "Input new name",
                      icon: Icon(Icons.edit, color: Theme.of(context).primaryColorDark),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                  Text(
                    "Email: ${original.email}",
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                  // TextFormField(
                  //   style: TextStyle(color: Colors.black),
                  //   controller: _emailController,
                  //   decoration: InputDecoration(
                  //     focusColor: Colors.blue,
                  //     labelText: original.email,
                  //     labelStyle: TextStyle(color: Colors.black, fontSize: 26.0),
                  //     icon: Icon(Icons.edit, color: Theme.of(context).primaryColorDark),
                  //     hintText: "Input new email",
                  //   ),
                  // ),
                ],
              ),
            );
          }),
    );
  }
}
