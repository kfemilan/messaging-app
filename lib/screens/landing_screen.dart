import 'package:flutter/material.dart';
// import 'package:messaging_app/models/Constants.dart';
import 'package:messaging_app/screens/login.dart';
import 'package:messaging_app/screens/register.dart';
import 'package:messaging_app/widgets/curve_painter.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({Key key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: CurvePainter(),
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Hero(
                          child: Image(
                              image: AssetImage('assets/landinglogo.png')),
                          tag: 'logo'),
                      Hero(
                          child: Image(
                              image: AssetImage('assets/landingsentence.png')),
                          tag: 'sentence'),
                    ],
                  ),
                  Spacer(flex: 2),
                  Hero(
                    tag: 'signin',
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.15,
                      child: ElevatedButton(
                        child: Text('Sign In'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  Hero(
                    tag: 'reg',
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.15,
                      child: TextButton(
                        child: Text('Register'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
