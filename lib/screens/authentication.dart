import 'package:flutter/material.dart';
import 'package:messaging_app/database/flutterfire.dart';

import 'home_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  AuthenticationScreen({Key key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height / 20,
                child: ElevatedButton(
                  child: Text('Register'),
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
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height / 20,
                child: ElevatedButton(
                  child: Text('Log In'),
                  onPressed: () async {
                    bool successful = await signIn(_email.text, _password.text);
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
            ],
          ),
        ),
      ),
    );
  }
}
