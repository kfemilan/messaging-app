import 'package:flutter/material.dart';
import 'package:messaging_app/screens/login.dart';
import 'package:messaging_app/screens/register.dart';

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
      body: Stack(children: [
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
                          tag: 'sentence')
                    ],
                  ),
                  Spacer(flex: 2),
                  Hero(
                    tag: 'lg',
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.15,
                        child: ElevatedButton(
                          child: Text('Log In'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF01A38B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        )),
                  ),
                  Spacer(flex: 1),
                  Hero(
                    tag: 'reg',
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.15,
                        child: TextButton(
                          child: Text('Register',
                              style: TextStyle(color: Color(0xFF01A38B))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        )),
                  ),
                ],
              )),
        ),
      ]),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    var path = Path();

    paint.color = Color(0xFF006455);
    paint.style = PaintingStyle.fill;

    // path.moveTo(0, size.height * 0.6); // Starting Point
    // path.quadraticBezierTo(size.width * 0.25, size.height * 0.5583, // Control (2nd)
    //     size.width * 0.5, size.height * 0.6); // End Point (Middle)
    // path.quadraticBezierTo(size.width * 0.75, size.height * 0.6417, // Control (4th)
    //     size.width * 1.0, size.height * 0.6); // End Point (End)
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);

    path.moveTo(0, size.height * 0.55);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.5083,
        size.width * 0.5, size.height * 0.55);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.5917,
        size.width * 1.0, size.height * 0.55);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(CurvePainter oldDelegate) => true;
}
