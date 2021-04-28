import 'package:flutter/material.dart';
import 'package:messaging_app/database/flutterfire.dart';

import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool hidePass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color(0xFF006455),
        body: Container(
      color: Color(0xFF006455),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Hero(
                      child: Image(
                        image: AssetImage('assets/registrationlogo.png'),
                        height: MediaQuery.of(context).size.height * 0.13,
                      ),
                      tag: 'logo'),
                ),
                Container(
                  child: Hero(
                      child: Image(
                        image: AssetImage('assets/registrationsentence.png'),
                        height: MediaQuery.of(context).size.height * 0.13,
                      ),
                      tag: 'sentence'),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 22),
                  TextFormField(
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          color: Color(0xff003f35),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      filled: true,
                      fillColor: Color(0xff01a38b),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff003f35), width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  TextFormField(
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    obscureText: hidePass,
                    controller: _password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: Color(0xff003f35),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      filled: true,
                      fillColor: Color(0xff01a38b),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                  Hero(
                    tag: 'reg',
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height / 20,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text('Register', style: TextStyle(color: Color(0xFF01A38B))),
                        onPressed: () async {
                          bool successful =
                              await register(_email.text, _password.text);
                          if (successful) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                            print('Successful');
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}