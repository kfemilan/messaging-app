import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging_app/widgets/alert_dialogs.dart';
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
  bool isUsingLocalImage = false;
  Color editIcon = primaryMedium;

  bool isEditing = false;
  final picker = ImagePicker();
  File _image;
  String imageUrl = kDefaultProfilePicture;
  String dataSent = "text"; // Either text or image

  Future getImage(String option) async {
    final pickedFile = await picker.getImage(
        source: option == "Camera" ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        dataSent = "image";
        isUsingLocalImage = true;
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
              bool success = false;
              if (isUsingLocalImage)
                success = await updateAccountProfilePicture(context);
              if (success) setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.2,
                    right: MediaQuery.of(context).size.width * 0.2,
                    bottom: MediaQuery.of(context).size.height * 0.5,
                  ),
                  content: Text(
                      success ? "Everything went A-OK!" : "Oops, try again.",
                      textAlign: TextAlign.center),
                ),
              );
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
            _usernameController.text = retrievedAccount.name;
            _usernameController.selection = TextSelection.fromPosition(
                TextPosition(offset: _usernameController.text.length));

            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          maxRadius: MediaQuery.of(context).size.width * 0.3,
                          backgroundImage:
                              !isUsingLocalImage // If not using local image, use retrieved
                                  ? (retrievedAccount.profilePic.isEmpty
                                      ? AssetImage('assets/defaultpp.jpg')
                                      : NetworkImage(
                                          retrievedAccount.profilePic))
                                  : (_image != null
                                      ? Image.file(_image, fit: BoxFit.cover)
                                          .image
                                      : AssetImage(
                                          'assets/defaultpp.jpg')), // Else, use local
                        ),
                        Container(
                          alignment: Alignment.topRight,
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
                                String imgSrc = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        PictureSourceSimpleDialog());
                                getImage(imgSrc);
                                success = true;
                              } on Exception catch (e) {
                                print(e.toString());
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * 0.2,
                                    right:
                                        MediaQuery.of(context).size.width * 0.2,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.5,
                                  ),
                                  content: Text(
                                      success
                                          ? "Image loaded successfully."
                                          : "Oops, try again.",
                                      textAlign: TextAlign.center),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          enabled: isEditing,
                          controller: _usernameController,
                          textCapitalization: TextCapitalization.sentences,
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: isEditing
                                  ? Theme.of(context).primaryColorLight
                                  : Colors.grey,
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
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.red),
                                  borderRadius: BorderRadius.circular(15.0)),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.close_rounded),
                                onPressed: () {
                                  _usernameController.text = "";
                                },
                              )),
                        ),
                      ),
                      IconButton(
                          icon: Icon(isEditing ? Icons.check : Icons.edit,
                              color: editIcon, size: 30),
                          onPressed: () async {
                            if (isEditing && _usernameController.text != "") {
                              await updateAccountName(context,
                                  widget.userId, _usernameController.text);
                            }
                            setState(() {
                              isEditing = !isEditing;
                              editIcon = (editIcon !=
                                      Theme.of(context).primaryColorLight)
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).primaryColorDark;
                            });
                          }),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Theme.of(context).primaryColor),
                    child: FittedBox(
                      child: Text(
                        retrievedAccount.email,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 4),
                ],
              ),
            );
          }),
    );
  }

  Future<bool> updateAccountProfilePicture(BuildContext context) async {
    bool success = true;
    try {
      final String imgName = basename(_image.path);
      final _firebaseStorage = firebase_storage.FirebaseStorage.instance;
      if (_image != null) {
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('${widget.userId}/$imgName')
            .putFile(_image);
        // Get image from firebase
        String downloadUrl = await snapshot.ref.getDownloadURL();
        updateAccountProfilePictureFirestore(widget.userId, downloadUrl);

        isUsingLocalImage = false;
        setState(() {
          imageUrl = retrievedAccount.profilePic = downloadUrl;
        });
      } else {
        print('No Image Path Received');
      }
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
        content: Text(
            success
                ? "Account picture updated successfully!"
                : "Oops, something bad happened! Try uploading your selfies next time.",
            textAlign: TextAlign.center),
      ),
    );
    return success;
  }

  Future<bool> updateAccountName(
      BuildContext context, String userId, String newUsername) async {
    bool success = true;
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
          content: Text("There are no changes to the account name.",
              textAlign: TextAlign.center),
        ),
      );
    } else {
      try {
        success = await updateAccountNameFirestore(userId, newUsername);
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
          content: Text(
              success
                  ? "Account name updated successfully!"
                  : "Oops, something bad happened! Better luck next time.",
              textAlign: TextAlign.center),
        ),
      );
    }
    return success;
  }
}
