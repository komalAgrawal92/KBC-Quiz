import 'package:flutter/material.dart';

class HexClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.lineTo(size.width * 0.07, size.height);
    path.lineTo(size.width * 0.93, size.height);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width * 0.93, 0);
    path.lineTo(size.width * 0.07, 0);
    path.lineTo(0, size.height * 0.5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class HexPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {

    final path = HexClipper().getClip(size);
    Paint paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path, paint);

    canvas.drawShadow(path, Colors.black, 5.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}