import 'package:flutter/material.dart';
import 'package:messaging_app/database/flutterfire.dart';
import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/widgets/curve_painter.dart';

import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool hidePass = true;
  Color buttonColor = primaryLight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: secondary,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                color: Theme.of(context).accentColor,
                height: MediaQuery.of(context).viewInsets.bottom > 0
                    ? 0
                    : MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Hero(
                            child: Image(
                                image: AssetImage('assets/lrlogo.png'),
                                height:
                                    MediaQuery.of(context).size.height * 0.07),
                            tag: 'logo'),
                        Hero(
                            child: Image(
                                image: AssetImage('assets/lrsentence.png'),
                                height:
                                    MediaQuery.of(context).size.height * 0.07),
                            tag: 'sentence')
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text('register',
                          style: Theme.of(context).textTheme.headline1),
                    ),
                  ],
                )),
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.08),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name',
                          style: Theme.of(context).textTheme.headline6),
                      Spacer(),
                      TextFormField(
                        controller: _name,
                        style: Theme.of(context).textTheme.bodyText2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).primaryColorDark,
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
                        ),
                      ),
                      Spacer(),
                      Text('Email',
                          style: Theme.of(context).textTheme.headline6),
                      Spacer(),
                      TextFormField(
                        controller: _email,
                        style: Theme.of(context).textTheme.bodyText2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).primaryColorDark,
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
                        ),
                      ),
                      Spacer(),
                      Text('Password',
                          style: Theme.of(context).textTheme.headline6),
                      Spacer(),
                      TextFormField(
                        controller: _password,
                        obscureText: hidePass,
                        style: Theme.of(context).textTheme.bodyText2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).primaryColorDark,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.visibility),
                            color: buttonColor,
                            onPressed: () {
                              setState(() {
                                buttonColor = (buttonColor ==
                                        Theme.of(context).accentColor)
                                    ? Theme.of(context).primaryColorLight
                                    : Theme.of(context).accentColor;
                                hidePass = !hidePass;
                                print(hidePass);
                              });
                            },
                          ),
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
                        ),
                      ),
                      Spacer(flex: 3),
                      Row(
                        children: [
                          Spacer(),
                          Hero(
                            tag: 'reg',
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: TextButton(
                                child: Text('Register'),
                                onPressed: () async {
                                  bool successful = await register(
                                      _email.text, _password.text, _name.text);
                                  if (successful) {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(flex: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage {}
