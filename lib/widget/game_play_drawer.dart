import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kbc_quiz/model/question_options.dart';
import 'package:kbc_quiz/provider/screen_state.dart';
import 'package:kbc_quiz/screen/game_play_screen.dart';
import 'package:kbc_quiz/screen/level_screen.dart';
import 'package:provider/provider.dart';

class GamePlayDrawer extends StatefulWidget{

  @override
  _GamePlayDrawerState createState() {
    print("Create state");
   return _GamePlayDrawerState();
  }

}

class _GamePlayDrawerState extends State<GamePlayDrawer> with TickerProviderStateMixin{
  final double maxSlide = 225.0;
  AnimationController _animationController;
//  Future<List<QuestionOptions>> _futureQuestions;

  @override
  void initState() {
    super.initState();
    print("init state drawer");
//    _futureQuestions = getQuestions();
    _animationController = AnimationController(vsync: this,
    duration: Duration(milliseconds: 1500))..addStatusListener((status) {
      if(AnimationStatus.completed == status) {
        _animationController.reverse();
      }
    });
  }

  void toggle() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    var gamePlayScreen = GamePlayScreen();
    var levelScreen = LevelScreen();
    return ChangeNotifierProvider(
      create: (context) => ScreenState(),//toggle: toggle),
      child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            double slide = maxSlide * _animationController.value;
            double scale = 1 - (_animationController.value * 0.3);
            return Stack(children: <Widget>[
              levelScreen,
              Transform(
                  transform: Matrix4.identity()
                    ..translate(slide)
                    ..scale(scale),
                  alignment: Alignment.centerLeft,
                  child: gamePlayScreen
              ),
            ]);
          }),
    );
  }

  Future<String> loadQuestions() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/json/questions.json');
  }

  Future<List<QuestionOptions>> getQuestions() async {
    String response = await loadQuestions();
    final parsed =
    json.decode(response.toString()).cast<Map<String, dynamic>>();
    List<QuestionOptions> que = parsed
        .map<QuestionOptions>((json) => QuestionOptions.fromJson(json))
        .toList();
    que.shuffle();
    return que.sublist(0, 16);
  }

  @override
  void dispose() {
    print("disposed drwaer");
    _animationController.dispose();
    super.dispose();
  }
}
