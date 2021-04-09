import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_quiz/model/question_options.dart';
import 'package:kbc_quiz/provider/screen_state.dart';
import 'package:kbc_quiz/screen/error.dart';
import 'package:kbc_quiz/screen/level_screen.dart';
import 'package:kbc_quiz/util/play_audio.dart';
import 'package:kbc_quiz/util/util.dart';
import 'package:kbc_quiz/widget/game_play_builder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// @See https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51
///

class GamePlayScreen extends StatefulWidget {
  final List<String> queSetNames;
  GamePlayScreen({Key key, this.queSetNames}) : super(key: key);

  @override
  _GamePlayScreenState createState() => _GamePlayScreenState();
}


class _GamePlayScreenState extends State<GamePlayScreen> {
  Future<List<QuestionOptions>> _futureQuestions;

  @override
  void initState() {
    super.initState();
    print("gamePlayscreen_init");
    _futureQuestions = getQuestions();
    PlayAudio().gamePlay();
  }

  @override
  Widget build(BuildContext context) {
    print('game screen build');
    ScreenState state = Provider.of<ScreenState>(context);
    List<String> level = LevelScreen.reversedList[state.correctAnswerCount].split(" ");
    return  WillPopScope(
        onWillPop: () => Util.onWillPop(context),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).buttonColor,
            elevation: 0.0,
            bottom: PreferredSize(child: Container(color: Colors.green, height: 4.0,), preferredSize: Size.fromHeight(4.0)),
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("${level[0]}",
                style: GoogleFonts.mcLaren(fontWeight: FontWeight.bold, fontSize: 25.0), ),
                SizedBox(width: 20.0,),
                Icon(Icons.fast_forward),
                SizedBox(width: 20.0,),
                Text("₹ " + level[1],
                  style: GoogleFonts.mcLaren(fontWeight: FontWeight.bold, fontSize: 25.0), ),
              ],
            ),
          ),
          body: Center(
            child: Container(
              decoration: Util.gradientBackground(),
              child: FutureBuilder(
                  future: _futureQuestions,
                  builder: (context, snapshot) {
                    Widget gamePlay;
                    if (snapshot.hasData) {
                      gamePlay = GamePlayBuilder(
                          snapshot.data[state.value]);
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      gamePlay = Error();
                    } else {
                      gamePlay = Container(
                        decoration: Util.gradientBackground(),
                        child: Center(
                          child: CircularProgressIndicator(value:0.6, backgroundColor: Theme.of(context).textSelectionColor,),
                        ),
                      );
                    }
                    return gamePlay;
                  }),
            ),
          ),
        ),
    );
  }


  Future<String> loadQuestions() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    String locale = preference.getBool(Util.locale) ? Util.english : Util.hindi;
    String key = locale == Util.english ? "en_set_number" : "hi_set_number";
    int questionSet = preference.getInt(key) ?? 0;

    List<String> queSetNames = widget.queSetNames.where((element) => element.contains('/$locale/')).toList();
    int limit = queSetNames.length;

    int indexToLoad = questionSet++;
    if (questionSet >= limit) {
      questionSet = 0;
    }
    preference.setInt(key, questionSet);

    return await DefaultAssetBundle.of(context)
        .loadString(queSetNames[indexToLoad]);
  }
  

  Future<List<QuestionOptions>> getQuestions() async {
    String response = await loadQuestions();
    final parsed =
    json.decode(response.toString()).cast<Map<String, dynamic>>();
    List<QuestionOptions> que = parsed
        .map<QuestionOptions>((json) => QuestionOptions.fromJson(json))
        .toList();

    List<QuestionOptions> easyQues = que.where((element) => element.level == "1").toList();
    List<QuestionOptions> intermediateQues = que.where((element) => element.level == "2").toList();
    List<QuestionOptions> hardQues = que.where((element) => element.level == "3").toList();
    que.clear();
    easyQues.shuffle();
    intermediateQues.shuffle();
    hardQues.shuffle();
    que.addAll(easyQues);
    que.addAll(intermediateQues);
    que.addAll(hardQues);
    return que;
  }



}
