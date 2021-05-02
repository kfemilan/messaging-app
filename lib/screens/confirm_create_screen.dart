import 'package:flutter/material.dart';
import 'package:messaging_app/database/flutterfire.dart';
import 'package:messaging_app/models/Account.dart';

import 'conversation_screen.dart';

class ConfirmCreateScreen extends StatefulWidget {
  ConfirmCreateScreen({Key key, this.selected}) : super(key: key);

  final List<Account> selected;

  @override
  _ConfirmCreateScreenState createState() => _ConfirmCreateScreenState();
}

class _ConfirmCreateScreenState extends State<ConfirmCreateScreen> {
  TextEditingController _gcName = new TextEditingController();
  List<Account> finalSelected;

  @override
  void initState() {
    finalSelected = widget.selected;
    print(finalSelected);
    super.initState();
  }

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
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConversationScreen()));
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
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.1,
              child: TextField(
                textCapitalization: TextCapitalization.words,
                controller: _gcName,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).primaryColor,
                    hintText: 'Conversation Name',
                    hintStyle: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600),
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
                    prefixIcon: Icon(
                      Icons.title_outlined,
                      color: Theme.of(context).primaryColorDark,
                    )),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                child: Container(
                  color: Theme.of(context).accentColor,
                  child: ListView.builder(
                      itemCount: widget.selected.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(finalSelected[i].name[0].toUpperCase()),
                          ),
                          title: Text(finalSelected[i].name),
                          trailing: IconButton(
                            icon: Icon(Icons.close_rounded,
                                color: Theme.of(context).primaryColorDark),
                            onPressed: () {
                              setState(() {
                                finalSelected.removeWhere((element) =>
                                    element.id == finalSelected[i].id);
                                if (finalSelected.length == 0) {
                                  Navigator.pop(context);
                                }
                              });
                            },
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
