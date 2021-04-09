import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kbc_quiz/animation/slide_screen_animation.dart';
import 'package:kbc_quiz/provider/screen_state.dart';
import 'package:kbc_quiz/screen/level_screen.dart';
import 'package:kbc_quiz/widget/expert_dialog.dart';
import 'package:kbc_quiz/widget/bar_chart.dart';
import 'package:kbc_quiz/util/play_audio.dart';
import 'package:kbc_quiz/util/util.dart';
import 'package:kbc_quiz/widget/life_line_icon.dart';
import 'package:kbc_quiz/widget/question_builder.dart';
import 'package:kbc_quiz/widget/options_builder.dart';
import 'package:kbc_quiz/model/question_options.dart';
import 'package:provider/provider.dart';

class GamePlayBuilder extends StatefulWidget {
  final QuestionOptions _questionOptions;

  GamePlayBuilder(this._questionOptions);

  @override
  _GamePlayBuilderState createState() => _GamePlayBuilderState();
}

class _GamePlayBuilderState extends State<GamePlayBuilder> with TickerProviderStateMixin{

  toggle() {
    Navigator.push(context,
        SlideScreenAnimation(enterPage: LevelScreen()));
  }

  bool enableAudiencePoll = true;
  bool enableExpertCall = true;
  bool enableFlip = true;
  bool enableFiftyFifty = true;

  @override
  Widget build(BuildContext context) {
    ScreenState state = Provider.of<ScreenState>(context);
    for (int i = 0; i < widget._questionOptions.options.length; i++) {
      Map<String, Object> map = widget._questionOptions.options[i];
      if ((map[Util.option] as String).trim().length > 0 &&
          !(map[Util.option] as String).contains(":"))
        map[Util.option] =
            getOptionFromIndex(i, addColon: true) + map[Util.option];
    }
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Spacer(),
            QuestionBuilder(widget._questionOptions.question),
            Spacer(flex:2),
            Column(children: widget._questionOptions.options.map((optionText) =>
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: OptionBuilder(optionText, toggle),
            )).toList(),),
            Spacer(flex:8),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).buttonColor,
              border: Border(top: BorderSide(color: Colors.green, width: 5.0),),),
              padding: EdgeInsets.all(15.0),

              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    LifeLineIcon(
                      filler: Icons.people_outline,
                      callback: () => audiencePoll(state.isEnabled),
                      isEnabled: enableAudiencePoll,
                    ),
                    LifeLineIcon(
                      filler: Icons.phone_in_talk,
                      callback: () => expertCall(state.isEnabled),
                      isEnabled: enableExpertCall,
                    ),
                    LifeLineIcon(
                      filler: Icons.rotate_90_degrees_ccw,
                      callback: () => flipQuestion(state),
                      isEnabled: enableFlip,
                    ),
                    LifeLineIcon(
                      filler: "50:50",
                      callback: () => fiftyFifty(state.isEnabled),
                      isEnabled: enableFiftyFifty,
                    ),
                  ]),
            ),

          ],
        ),

    );
  }

  void fiftyFifty(bool isEnabled) {
    if (isEnabled) {
      PlayAudio().lifeline();
      var incorrectOption;
      for (int i = 0; i < 4; i++) {
        Map<String, Object> temp = widget._questionOptions.options[i];
        if (Util.isCorrect(temp[Util.correct])) {
          var value = _generateRandom(i, isFiftyFifty: true);
          incorrectOption = widget._questionOptions.options[value];
          break;
        }
      }

      widget._questionOptions.options.forEach((element) {
        Map<String, Object> map = element;
        if (!Util.isCorrect(map[Util.correct])  && !identical(incorrectOption, map)) {
          setState(() {
            map[Util.option] = '';
          });
        } else {
          setState(() {
            map[Util.option] = (map[Util.option] as String).substring(3);
          });
        }
      });
      setState(() {
        enableFiftyFifty = false;
      });
    }
  }

  void flipQuestion(ScreenState state) {
    if (state.isEnabled) {
      state.setIsEnabled(false);
      PlayAudio().lifeline();
      setState(() => enableFlip = false);
      state.increment((){},showLevelScreen: false,);
    }
  }

  void expertCall(bool isEnabled) {
    if (isEnabled) {
      PlayAudio().lifeline();
      for (int i = 0; i < 4; i++) {
        Map<String, Object> temp = widget._questionOptions.options[i];
  
        if (Util.isCorrect(temp[Util.correct])) {
          showDialog<double>(
            context: context,
            builder: (context) => ExpertDialog(temp[Util.option]),
          );
        }
      }
      setState(() => enableExpertCall = false);
    }
  }

  void audiencePoll(bool isClickable) {
    if(isClickable) {
      PlayAudio().lifeline();
      Map<String, int> pollResults = new Map();
      int _index = 0;
      const int _correctLimit = 70;
      int _wrongLimit = 50;

      widget._questionOptions.options
          .map((e) => e as Map<String, Object>)
          .forEach((element) {
        if (element['correct'] == 'yes') {
          pollResults[getOptionFromIndex(_index++)] =
              _generateRandom(_correctLimit);
        } else if ((element[Util.option] as String).trim().length > 0) {
          pollResults[getOptionFromIndex(_index++)] =
              _generateRandom(_wrongLimit);
          _wrongLimit -= 10;
        }
      });

      List<OrdinalPoll> pollResultsData = [];
      pollResults.forEach(
              (key, value) => pollResultsData.add(new OrdinalPoll(key, value)));

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SimpleBarChart.withData(pollResultsData)));
      setState(() => enableAudiencePoll = false);
    }
    
  }

  int _generateRandom(int limit, {bool isFiftyFifty = false}) {
    int _finalValue = isFiftyFifty ? limit : -1;
    Random random = new Random();
    while (isFiftyFifty ? _finalValue == limit : _finalValue < limit - 20) {
      _finalValue = random.nextInt(isFiftyFifty ? 4 : limit);
    }
    return _finalValue;
  }

  String getOptionFromIndex(int index, {bool addColon = false}) {
    switch (index) {
      case 0:
        return addColon ? 'A: ' : 'A';
      case 1:
        return addColon ? 'B: ' : 'B';
      case 2:
        return addColon ? 'C: ' : 'C';
      default:
        return addColon ? 'D: ' : 'D';
    }
  }

}
