import 'package:flutter/material.dart';
import 'package:messaging_app/database/flutterfire.dart';
import 'package:messaging_app/models/Account.dart';

import 'conversation_screen.dart';

class ConfirmCreateScreen extends StatefulWidget {
  ConfirmCreateScreen({Key key, this.selected}) : super(key: key);

  List<Account> selected;

  @override
  _ConfirmCreateScreenState createState() => _ConfirmCreateScreenState();
}

class _ConfirmCreateScreenState extends State<ConfirmCreateScreen> {
  TextEditingController _gcName = new TextEditingController();

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
              bool successful = await createGC(widget.selected, _gcName.text);
              if (successful) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConversationScreen()));
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: _gcName,
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                    itemCount: widget.selected.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: CircleAvatar(),
                        title: Text(widget.selected[i].name),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
