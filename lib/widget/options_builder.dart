import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_quiz/animation/button_scale_animation.dart';
import 'package:kbc_quiz/provider/screen_state.dart';
import 'package:kbc_quiz/screen/level_screen.dart';
import 'package:kbc_quiz/util/hex_clipper.dart';
import 'package:kbc_quiz/util/play_audio.dart';
import 'package:kbc_quiz/util/util.dart';
import 'package:kbc_quiz/widget/countdown_timer.dart' as countdownanimation;
import 'package:provider/provider.dart';

class OptionBuilder extends StatefulWidget {
  final Map<String, Object> _text;
  final VoidCallback toggle;
  OptionBuilder(this._text, this.toggle);

  @override
  _OptionBuilderState createState() => _OptionBuilderState();
}

class _OptionBuilderState extends State<OptionBuilder>
    with SingleTickerProviderStateMixin {
  AnimationController _colorController;


  Animatable<Color> _animatable = TweenSequence([
    TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Color(0xFF061D95),
          end: Colors.greenAccent,
        )),
  ]);


  initState() {
    super.initState();
    _colorController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    ScreenState state = Provider.of<ScreenState>(context);
    if(Util.isCorrect(widget._text[Util.correct])) {
      state.setAnimate(_animateCorrect);
    }
    print('buildState option builder');
    return ButtonScaleAnimation(
        callBack: () {
          if (state.isEnabled && widget._text[Util.option]!='') {
            state.setIsEnabled(false);
            verifyAnswer(state);
          }
        },
      child: CustomPaint(
        painter: HexPainter(),
        child: ClipPath(
          clipper: HexClipper(),
          child: AnimatedBuilder(
            animation: _colorController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 9),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 2500),
                opacity: state.isVisible ? 1.0 : 0.0,
                child: Text(
                  widget._text[Util.option],
                  style: GoogleFonts.mcLaren(
                      fontSize: 16.0,
                      color: Theme.of(context).textSelectionColor,
                      letterSpacing: 1.0),
                ),
              ),
            ),
            builder: (context, child) {
              return Container(
                alignment: AlignmentDirectional.centerStart,
                width: 300,
                color: _animatable
                    .evaluate(AlwaysStoppedAnimation(_colorController.value)),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }

  void verifyAnswer(ScreenState state) async {
    PlayAudio().stopCountDown();
    bool isCorrect = Util.isCorrect(widget._text[Util.correct]);
    if (isCorrect) {
      PlayAudio().rightAnswer();
      if(state.correctAnswerCount == 14) {
        countdownanimation.animcontrollervalue.stop();
        Util.getGeneralDialog(context,"1 Crore","Congratulations!!!");
      } else {
        _animateCorrect();
        state.increment(widget.toggle, animationController: _colorController);
      }
    } else {
      PlayAudio().wrongAnswer();
      _animateIncorrect(state);
      await Future.delayed(Duration(seconds: 3));
      String winPrize = state.correctAnswerCount == 0 ? '0 0' : LevelScreen.reversedList[state.correctAnswerCount - 1];
      List<String> prizeMoney = winPrize.split(' ');
      //Util.onWillPopGameOver(context, prizeMoney[1]);
      Util.getGeneralDialog(context,prizeMoney[1],"GameOver");
    }
  }

  void _animateCorrect() {
    countdownanimation.animcontrollervalue.stop();
    _colorController.repeat(reverse: true);
  }

  void _animateIncorrect(ScreenState state) {
    _animatable = TweenSequence([
      TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Theme.of(context).buttonColor,
            end: Colors.redAccent,
          )),
    ]);
    _animateCorrect();
    state.highlightCorrect();
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
    print('dispose called option builder');
  }
}
