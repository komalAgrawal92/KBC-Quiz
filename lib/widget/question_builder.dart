import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_quiz/provider/screen_state.dart';
import 'package:kbc_quiz/screen/level_screen.dart';
import 'package:kbc_quiz/util/hex_clipper.dart';
import 'package:kbc_quiz/util/util.dart';
import 'package:kbc_quiz/widget/circular_text.dart';
import 'package:kbc_quiz/widget/countdown_timer.dart';
import 'package:provider/provider.dart';

class QuestionBuilder extends StatefulWidget {
  final String _text;

  QuestionBuilder(this._text);

  @override
  _QuestionBuilderState createState() => _QuestionBuilderState();
}

class _QuestionBuilderState extends State<QuestionBuilder> {
  @override
  Widget build(BuildContext context) {
    ScreenState state = Provider.of<ScreenState>(context);
    HexClipper clipper = HexClipper();
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            //MyArc(),
            CircularText("", 35, 33),
            Container(
              width: 70.0,
              padding: EdgeInsets.only(left: 2, top: 25, bottom: 6),
              child: CountDownTimer(
                secondsRemaining: state.timer,
                whenTimeExpires: () {
                  prizeMoney(state.correctAnswerCount);
                },
                countDownTimerStyle: GoogleFonts.mcLaren(color: Colors.white),
              ),
            ),
          ],
        ),
        CustomPaint(
          painter: HexPainter(),
          child: ClipPath(
            clipper: clipper,
            child: Container(
              color: Theme.of(context).buttonColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 9.0, horizontal: 25.0),
                child: Center(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 2500),
                    opacity: state.isVisible ? 1.0 : 0.0,
                    child: Text(
                      widget._text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mcLaren(
                        fontSize: 18.0,
                        color: Theme.of(context).textSelectionColor,
                        letterSpacing: 1.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void prizeMoney(int counter) {
    String winPrize;

    if (counter == 0) {
      winPrize = '0 0';
    } else {
      winPrize = LevelScreen.reversedList[counter - 1];
    }

    List<String> prizeMoney = winPrize.split(' ');

    Util.getGeneralDialog(context, prizeMoney[1], "TimeOut");
  }
}
