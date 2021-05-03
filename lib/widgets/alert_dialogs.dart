import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:messaging_app/models/Constants.dart';

// Separated since it was getting a bit too unreadable
class DeleteConversationAlertDialog extends StatelessWidget {
  const DeleteConversationAlertDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Leave Conversation?", style: Theme.of(context).textTheme.bodyText1),
      actions: <Widget>[
        TextButton(
          child: Text("No", style: TextStyle(color: Colors.grey)),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).primaryColorLight),
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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        "Edit Conversation",
        style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 20.0),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Conversation Name", style: TextStyle(fontSize: 16.0)),
            TextFormField(
              controller: _convoNameController,
              style: TextStyle(color: Colors.black, fontSize: 14.0),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Conversation Name",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
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
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).primaryColorLight),
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: primaryLight),
            child: Text("Confirm Changes", style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (_convoNameController.text.isEmpty) Navigator.of(context).pop(false);
              try {
                FirebaseFirestore.instance.collection("Conversations").doc(widget.conversationId).update({'name': _convoNameController.text});
                Navigator.of(context).pop(true);
              } on Exception catch (e) {
                print(e.toString());
                Navigator.of(context).pop(false);
              }
              Navigator.of(context).pop(false);
              this.dispose();
            },
          ),
        ),
      ],
    );
  }
}
