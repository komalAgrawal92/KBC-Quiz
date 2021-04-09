import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kbc_quiz/blob.dart';
import 'package:kbc_quiz/util/util.dart';

class Logo extends StatefulWidget {
  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  // rotation and scale animations
  AnimationController _rotationController;
  AnimationController _scaleController;
  double _rotation = 0;
  double _scale = 0.85;

  bool get _showWaves => !_scaleController.isDismissed;

  void _updateRotation() => _rotation = _rotationController.value * 2 * pi;

  void _updateScale() => _scale = (_scaleController.value * 0.2) + 0.85;

  @override
  void initState() {
    _rotationController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(() => setState(_updateRotation))
          ..repeat();

    _scaleController =
        AnimationController(vsync: this, duration: _kToggleDuration)
          ..addListener(() => setState(_updateScale));

    super.initState();
  }

  void _onToggle() {
    if (_scaleController.isCompleted) {
      _scaleController.reverse();
    } else {
      _scaleController.forward();
    }
  }

  Widget _buildIcon() {
    _onToggle();
    return SizedBox.expand(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 4, top: 35),
          child: Text(
            "KBC",
            style: Util.getNameTextStyle(context),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 2, top: 10),
          child: Text(
            "QUIZ 2020",
            style: Util.getNameTextStyle(context).copyWith(
              fontSize: 22,
              letterSpacing: 4,
            ),
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 48, minHeight: 48),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_showWaves) ...[
            Blob(
              color: Color(0xff0092ff),
              scale: _scale,
              rotation: _rotation,
            ),
            Blob(
              color: Color(0xff4ac7b7),
              scale: _scale,
              rotation: _rotation * 2 - 30,
            ),
            Blob(
              color: Color(0xffa4a6f6),
              scale: _scale,
              rotation: _rotation * 3 - 45,
            ),
          ],
          Container(
            constraints: BoxConstraints.expand(),
            child: AnimatedSwitcher(
              child: _buildIcon(),
              duration: _kToggleDuration,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).buttonColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}
