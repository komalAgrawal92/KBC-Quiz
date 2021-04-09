import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kbc_quiz/app_localizations.dart';
import 'package:kbc_quiz/logo.dart';
import 'package:kbc_quiz/animation/slide_screen_animation.dart';
import 'package:kbc_quiz/screen/settings_screen.dart';
import 'package:kbc_quiz/util/util.dart';
import 'package:kbc_quiz/widget/button.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'game_play_screen.dart';
import 'package:url_launcher/url_launcher.dart';


class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  double radius = 0.3;
  List<String> questionSetNames;
  bool _isEnglish = true;

  setLocale(bool val) {
    _isEnglish = val;
  }

  @override
  void initState() {
    super.initState();
    print("menuscreen_init");
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this, value: 0.1);
    _controller.forward();
    setLanguage();
  }

  @override
  Widget build(BuildContext context) {
    print('menu build');
    Future<double>.delayed(Duration(milliseconds: 50)).then((value) {
      if (radius != 2.0) {
        setState(() => radius = 2.0);
      }
    });
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: AnimatedContainer(
        decoration: Util.gradientBackground(radius: radius, context: context),
        duration: Duration(milliseconds: 1300),
        curve: Curves.easeInQuart,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Spacer(flex: 2),
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Logo(),
                  ),
                ],
              ),
              Spacer(flex: 2),
              Button(
                  buttonText:
                      AppLocalizations.of(context).translate("play_button"),
                  callback: _headToPlay),
              Spacer(),
              Button(
                buttonText:
                    AppLocalizations.of(context).translate("settings_button"),
                callback: _headToSettings,
              ),
              Spacer(),
              Button(
                buttonText: AppLocalizations.of(context).translate("more_apps"),
                callback: _headToMoreApps
              ),
              Spacer(flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share),
                    color: Colors.white,
                    iconSize: 40,
                    onPressed: () => Share.share(
                        "KBC QUIZ 2020 - Download it now to boost your knowledge.\n" +
                            "https://play.google.com/store/apps/details?id=com.siaworld.kbc"),
                  ),
                  SizedBox(width: 50),
                  IconButton(
                      icon: Icon(Icons.rate_review),
                      color: Colors.white,
                      iconSize: 40,
                      onPressed: () {
                        StoreRedirect.redirect(
                            androidAppId: "com.siaworld.kbc");
                      }),
                ],
              ),
              Spacer(flex: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Developed by: Gauri | Abhinav'),
                  Text('v1.1.5'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _headToPlay(final BuildContext context) {
    Navigator.push(
      context,
      SlideScreenAnimation(
        enterPage: GamePlayScreen(
          queSetNames: questionSetNames,
        ),
      ),
    );
  }

  void _headToSettings(final BuildContext context) {
    showDialog<double>(
      context: context,
      builder: (context) => Settings(
        setLocale: setLocale,
        isEnglish: _isEnglish,
      ),
    );
  }

  void _headToMoreApps(final BuildContext context)  async {
    const url =
        'https://play.google.com/store/apps/developer?id=Idyllic+Apps';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  void setLanguage() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    _isEnglish = preference.getBool(Util.locale) ?? true;
    preference.setBool(Util.locale, _isEnglish);
    loadQuestionSetName();
  }

  Future<void> loadQuestionSetName() async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString(Util.assetManifest);
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    questionSetNames =
        manifestMap.keys.where((String key) => key.contains('.json')).toList();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}
