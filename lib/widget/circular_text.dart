import 'package:flutter/material.dart';

class CircularText extends StatelessWidget {
  final circularText;
  final double outerRadius;
  final double innerRadius;

  CircularText(this.circularText, this.outerRadius, this.innerRadius);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      child: CircleAvatar(
        radius: outerRadius,
        backgroundColor: Colors.greenAccent,
        child: CircleAvatar(
          radius: innerRadius,
          backgroundColor: Theme.of(context).buttonColor,
          child: ClipOval(
            child: null,
          ),
        ),
      ),
    );
  }
}
