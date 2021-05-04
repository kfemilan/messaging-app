import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:messaging_app/models/Constants.dart';

class PictureSourceSimpleDialog extends StatelessWidget {
  const PictureSourceSimpleDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Select source for image:", style: TextStyle(color: Colors.black)),
      children: <Widget>[
        SimpleDialogOption(
          child: Padding(padding: EdgeInsets.symmetric(vertical: 10.0), child: Text('Camera', style: TextStyle(color: Colors.black))),
          onPressed: () => Navigator.pop(context, "Camera"),
        ),
        SimpleDialogOption(
          child: Padding(padding: EdgeInsets.symmetric(vertical: 10.0), child: Text('Gallery', style: TextStyle(color: Colors.black))),
          onPressed: () => Navigator.pop(context, "Gallery"),
        ),
      ],
    );
  }
}

// Separated since it was getting a bit too unreadable
class SignOutAlertDialog extends StatelessWidget {
  const SignOutAlertDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Sign out?", style: Theme.of(context).textTheme.headline3),
      actions: <Widget>[
        TextButton(
          child: Text("No", style: TextStyle(color: Colors.grey)),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColorLight),
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: primaryLight),
            child: Text("Yes", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ),
      ],
    );
  }
}

class DeleteConversationAlertDialog extends StatelessWidget {
  const DeleteConversationAlertDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Leave Conversation?", style: Theme.of(context).textTheme.headline3),
      actions: <Widget>[
        TextButton(
          child: Text("No", style: TextStyle(color: Colors.grey)),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColorLight),
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: primaryLight),
            child: Text("Yes", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ),
      ],
    );
  }
}

class EditConversationAlertDialog extends StatefulWidget {
  EditConversationAlertDialog(this.convoName, this.conversationId, {Key key}) : super(key: key);
  final String convoName, conversationId;
  @override
  _EditConversationAlertDialogState createState() => _EditConversationAlertDialogState();
}

class _EditConversationAlertDialogState extends State<EditConversationAlertDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _convoNameController = new TextEditingController(text: "Conversation Name");
    _convoNameController.text = widget.convoName;
    _convoNameController.selection = TextSelection.fromPosition(TextPosition(offset: _convoNameController.text.length));
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        "Edit Conversation Name",
        style: Theme.of(context).textTheme.headline3,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _convoNameController,
              style: Theme.of(context).textTheme.bodyText2,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).primaryColorLight,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Theme.of(context).accentColor,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                errorStyle: Theme.of(context).textTheme.subtitle2,
                errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red), borderRadius: BorderRadius.circular(15.0)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear_rounded),
                  onPressed: () {
                    _convoNameController.text = "";
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Discard", style: TextStyle(color: Colors.grey)),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColorLight),
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: primaryLight),
            child: Text("Confirm", style: TextStyle(color: Colors.white)),
            onPressed: () {
              print(_convoNameController.text);
              if (_convoNameController.text.isEmpty) Navigator.of(context).pop(false);
              FirebaseFirestore.instance.collection("Conversations").doc(widget.conversationId).update({'name': _convoNameController.text});
              Navigator.of(context).pop(true);
            },
          ),
        ),
      ],
    );
  }
}
