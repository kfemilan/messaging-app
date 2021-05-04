import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:messaging_app/database/flutterfire.dart';
import 'package:messaging_app/models/Account.dart';
import 'package:messaging_app/models/Constants.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen(this.userId, {Key key}) : super(key: key);
  final String userId;
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  Account retrievedAccount = Account();
  bool ishasLoadedImage = false;

  final picker = ImagePicker();
  File _image;
  String imageUrl = kDefaultProfilePicture;
  String dataSent = "text"; // Either text or image

  Future uploadImageToFirebase() async {
    final imgName = basename(_image.path);
    final _firebaseStorage = firebase_storage.FirebaseStorage.instance;
    if (_image != null) {
      //Upload to Firebase
      var snapshot = await _firebaseStorage.ref().child('${widget.userId}/$imgName').putFile(_image);
      // Get image from firebase
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      print('No Image Path Received');
    }
  }

  Future getImage(String option) async {
    final pickedFile = await picker.getImage(source: option == "Camera" ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        dataSent = "image";
      }
    });
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
              if (_usernameController.text == retrievedAccount.name) {
                // No changes
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.2,
                      right: MediaQuery.of(context).size.width * 0.2,
                      bottom: MediaQuery.of(context).size.height * 0.5,
                    ),
                    content: Text("There are no changes to the account name.", textAlign: TextAlign.center),
                  ),
                );
              } else {
                bool success = false;
                try {
                  success = await updateAccountName(widget.userId, _usernameController.text);
                } on Exception catch (e) {
                  print(e.toString());
                  success = false;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.2,
                      right: MediaQuery.of(context).size.width * 0.2,
                      bottom: MediaQuery.of(context).size.height * 0.5,
                    ),
                    content: Text(success ? "Account name updated successfully!" : "Oops, something bad happened! Better luck next time.",
                        textAlign: TextAlign.center),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: getAccount(widget.userId),
          builder: (BuildContext context, AsyncSnapshot accountSnapshot) {
            if (!accountSnapshot.hasData) return SizedBox(height: 0, width: 0);

            retrievedAccount.name = accountSnapshot.data.name;
            retrievedAccount.email = accountSnapshot.data.email;
            retrievedAccount.profilePic = accountSnapshot.data.profilePic;

            return Container(
              constraints: BoxConstraints.expand(),
              alignment: Alignment.center,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.06,
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                ),
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColorLight,
                        maxRadius: MediaQuery.of(context).size.width * 0.3,
                        backgroundImage: !ishasLoadedImage // If wala pa naka load ug image, use retrieved
                            ? (retrievedAccount.profilePic.isEmpty ? AssetImage('assets/defaultpp.jpg') : NetworkImage(retrievedAccount.profilePic))
                            : Image.file(_image, fit: BoxFit.cover).image, // If naka load na bisag kaisa, use local
                      ),
                      Positioned(
                        top: 10.0,
                        right: 20.0,
                        child: MaterialButton(
                          shape: CircleBorder(),
                          color: Colors.white,
                          height: 60.0,
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColorDark,
                            size: 40.0,
                          ),
                          onPressed: () async {
                            bool success = false;
                            try {
                              getImage("gallery");
                              success = true;
                              ishasLoadedImage = true;
                            } on Exception catch (e) {
                              print(e.toString());
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.2,
                                  right: MediaQuery.of(context).size.width * 0.2,
                                  bottom: MediaQuery.of(context).size.height * 0.5,
                                ),
                                content: Text(success ? "Image loaded successfully." : "Oops, try again.", textAlign: TextAlign.center),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
                  TextFormField(
                    controller: _usernameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: retrievedAccount.name,
                      labelStyle: TextStyle(color: Colors.black, fontSize: 26.0, decorationColor: Colors.red),
                      hintText: "Input new name",
                      icon: Icon(Icons.edit, color: Theme.of(context).primaryColorDark),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                  Text(
                    "Email: ${retrievedAccount.email}",
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
