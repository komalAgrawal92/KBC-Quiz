import 'package:flutter/material.dart';
import 'package:kbc_quiz/animation/button_scale_animation.dart';
import 'package:kbc_quiz/util/hex_clipper.dart';
import 'package:kbc_quiz/util/play_audio.dart';
import 'package:kbc_quiz/util/util.dart';

class Button extends StatefulWidget {
  final String buttonText;
  final Function callback;
  final bool popUpButton;

  Button({this.buttonText, this.callback, this.popUpButton = false});

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HexClipper clipper = HexClipper();
    return ButtonScaleAnimation(
      child: CustomPaint(
        painter: HexPainter(),
        child: ClipPath(
          clipper: clipper,
          child: _getButton(context),
        ),
      ),
      callBack: () {
        PlayAudio().buttonClick();
        widget.callback(context);
      },
    );
  }

  Widget _getButton(BuildContext context) {
    Widget w;
    if(widget.popUpButton) {
      w = Container(
        width: 100,
        height: 35,
        color: Theme.of(context).buttonColor,
        child: Center(
          child: Text(
            widget.buttonText,
            style: Util.getPopBtnTxtStyle(context),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      );
    } else {
      w = Container(
        width: 200,
//        height: 50,
        color: Theme.of(context).buttonColor,
        child: Padding(
          padding:
          EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Center(
            child: Text(
              widget.buttonText,
              style: Util.getMenuBtnTxtStyle(context).copyWith(fontWeight:FontWeight.bold, letterSpacing: 3.5, fontSize: 18.0),
             // overflow: TextOverflow.ellipsis,
             // maxLines: 1,
            ),
          ),
        ),
      );
    }

    return w;
  }

}
