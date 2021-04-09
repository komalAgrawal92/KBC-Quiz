import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_quiz/provider/screen_state.dart';
import 'package:kbc_quiz/util/util.dart';
import 'package:provider/provider.dart';

import 'game_play_screen.dart';

class LevelScreen extends StatefulWidget {
  LevelScreen();

  @override
  State<StatefulWidget> createState() {
    return _LevelState();
  }

  static final List<String> levels = const [
    "15 1,CRORE",
    "14 50,00,000",
    "13 25,00,000",
    "12 12,50,000",
    "11 6,40,000",
    "10 3,20,000",
    "9 1,60,000",
    "8 80,000",
    "7 40,000",
    "6 20,000",
    "5 10,000",
    "4 5,000",
    "3 3,000",
    "2 2,000",
    "1 1,000",
  ];

  static final List<String> reversedList = new List.from(levels.reversed);
}

class _LevelState extends State<LevelScreen> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animatable<Color> _animatable = TweenSequence([
    TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Color(0xFF061D95),
          end: Colors.yellow,
        )),
  ]);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animationController.repeat(reverse: true);
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    ScreenState counter = Provider.of<ScreenState>(context);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      onWillPop: () => Util.onWillPop(context),
      child: Scaffold(
          appBar: AppBar(
            title: Text("LEVELS",
                style: GoogleFonts.mcLaren(
                    fontSize: 23.0,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textSelectionColor),
            textAlign: TextAlign.center,),
            elevation: 25.0,
            bottom: PreferredSize(child: Container(color: Colors.green, height: 4.0,), preferredSize: Size.fromHeight(4.0)),
            leading: Icon(Icons.arrow_drop_down_circle),
            centerTitle: true,
          ),
          body: Flex(
              direction: Axis.vertical,
              children: LevelScreen.levels.map((e) {
                List<String> info = e.split(" ");
                String levelNumber = info[0];
                String levelPrize = info[1];
                int levelNum = int.parse(levelNumber);
                bool atLevel = levelNum % 5 == 0;
                bool levelReached = levelNum == counter.correctAnswerCount;
                return Expanded(
                  flex: 1,
                  child: AnimatedBuilder(
                      animation: _animationController,
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //SizedBox(width: 120.0),
                            Text(levelNumber,
                              style: GoogleFonts.mcLaren(
                                color: atLevel
                                    ? Colors.green
                                    : Theme.of(context)
                                    .textSelectionColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,),
                            SizedBox(width: 20.0),
                            Icon(Icons.fast_forward),
                            SizedBox(width: 20.0),
                            Text(levelPrize,
                                style: GoogleFonts.mcLaren(
                                  color: atLevel
                                      ? Colors.green
                                      : Theme.of(context)
                                      .textSelectionColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      builder: (context, child) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          color: levelReached
                              ? null
                              : Theme.of(context).primaryColor,
                          decoration: levelReached
                              ? BoxDecoration(
                                  color: _animatable.evaluate(
                                      AlwaysStoppedAnimation(
                                          _animationController.value)),
                                )
                              : null,
                          child: child,
                        );
                      }),
                );
              }).toList())),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pop(context, MaterialPageRoute(
        builder: (context) => GamePlayScreen()
    )
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
