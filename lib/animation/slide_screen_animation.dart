import 'package:flutter/material.dart';

class SlideScreenAnimation extends PageRouteBuilder {
  final Widget enterPage;
  SlideScreenAnimation({this.enterPage})
      : super(
    pageBuilder: (context,animation,secondaryAnimation,) => enterPage,
    transitionDuration: Duration(milliseconds: 1000),
    transitionsBuilder: (context, animation, secondaryAnimation, Widget child,) {
      var begin = Offset(-1.0, 0.0);
      var end = Offset.zero;
      var tween = Tween(begin: begin, end: end);
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}