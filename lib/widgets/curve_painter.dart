import 'package:flutter/material.dart';
import 'package:messaging_app/models/Constants.dart';

class CurvePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    var path = Path();

    paint.color = primaryMedium;
    paint.style = PaintingStyle.fill;

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


class SmallCurvePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    var paint = Paint();
    var path = Path();

    paint.color = primaryDark;
    paint.style = PaintingStyle.fill;

    path.moveTo(0, size.height * 0.8); // Starting Point
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.7583, // Control (2nd)
        size.width * 0.5, size.height * 0.8); // End Point (Middle)
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.8417, // Control (4th)
        size.width * 1.0, size.height * 0.8); // End Point (End)
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SmallCurvePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(SmallCurvePainter oldDelegate) => false;
}