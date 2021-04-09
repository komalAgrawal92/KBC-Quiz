import 'package:flutter/material.dart';

class ButtonScaleAnimation extends StatefulWidget {

  final Widget child;
  final Function callBack;

  ButtonScaleAnimation({this.child, this.callBack});

  @override
  _ButtonScaleAnimationState createState() => _ButtonScaleAnimationState();
}

class _ButtonScaleAnimationState extends State<ButtonScaleAnimation> with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.10,
    )..addStatusListener((status) {
        if(status == AnimationStatus.completed) {
          _controller.reverse();
        }
      })..addListener(() { setState(() {});});
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTap: () {
        _controller.forward();
        widget.callBack();
      },
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
