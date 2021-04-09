import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_quiz/provider/screen_state.dart';
import 'package:kbc_quiz/widget/button.dart';
import 'package:provider/provider.dart';
import 'package:kbc_quiz/app_localizations.dart';

class Util {
  static final String englishPlayButton = 'PLAY';
  static final String hindiPlayButton = 'खेलें';
  static final String aboutButton = 'ABOUT';
  static final String helpButton = 'HELP';
  static final String englishSettingButton = 'SETTINGS';
  static final String hindiSettingButton = 'समायोजन';
  static final String englishButton = 'LANGUAGE';
  static final String hindiLocaleButton = 'भाषा';
  static final  String hindiSoundButton = 'ध्वनि';
  static final String english = 'en';
  static final String hindi = 'hi';
  static final String locale  = 'locale';

  static final String splashScreenButton = 'SPLASHSCREEN';
  static final String levelScreenButton = 'LEVELS';
  static final String gameOverScreenButton = 'GAMEOVER';
  static final String winScreenButton = 'WIN  ';
  static final String assetManifest = 'AssetManifest.json';

  static final String option = 'option';
  static final String correct = 'correct';
  static final String yes = "yes";

  static TextStyle getMenuBtnTxtStyle(BuildContext context) {
    return GoogleFonts.mcLaren(
        fontSize: 16.0, color: Theme.of(context).textSelectionColor);
  }

  static TextStyle getPopBtnTxtStyle(BuildContext context) {
    return GoogleFonts.mcLaren(
        fontSize: 18.0,
        color: Theme.of(context).textSelectionColor,
        letterSpacing: 1.0,
        fontWeight: FontWeight.w600);
  }

  static TextStyle getTextStyle(BuildContext context) {
    return GoogleFonts.mcLaren(
      letterSpacing: 1.0,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textSelectionColor,
      fontSize: 20.0,
    );
  }

  static TextStyle getNameTextStyle(BuildContext context) {
    return GoogleFonts.mcLaren(
      letterSpacing: 8.0,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textSelectionColor,
      fontSize: 35.0,
    );
  }

  static BoxDecoration gradientBackground(
      {double radius = 2.0, double focalRadius = 0.4, BuildContext context}) {
    return BoxDecoration(
      gradient: RadialGradient(
        colors: [
          Color(0xFF1e2a78),
          Colors.black87,
        ],
        radius: radius,
        focalRadius: 0.4,
      ),
    );
  }

  static Future<bool> onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            contentPadding: EdgeInsets.all(30.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 25.0,
            title: new Text(
              AppLocalizations.of(context).translate('exit'),
              style: Util.getTextStyle(context).copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            children: <Widget>[
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Button(
                    popUpButton: true,
                    buttonText: AppLocalizations.of(context).translate('yes'),
                    callback: (c) {
                      ScreenState state =
                          Provider.of<ScreenState>(context, listen: false);
                      state.reset();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                  Button(
                      popUpButton: true,
                      buttonText: AppLocalizations.of(context).translate('no'),
                      callback: (c) {
                        Navigator.pop(context, false);
                      }),
                ],
              ),
            ],
          ),
        )) ??
        false;
  }

  static bool isCorrect(String check) {
    return check == yes;
  }

  static SimpleDialog _getSimpleDialog(
      BuildContext context, String prizeMoney, String titleText) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(30.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 45.0,
      title: new Text(
        titleText,
        style: Util.getTextStyle(context).copyWith(
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.center,
      ),
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate('won') + '${prizeMoney}',
          style: Util.getPopBtnTxtStyle(context)
              .copyWith(fontWeight: FontWeight.w400, color: Colors.greenAccent),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10.0),
        Text(
          AppLocalizations.of(context).translate('restart'),
          style: Util.getMenuBtnTxtStyle(context).copyWith(
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Button(
              popUpButton: true,
              buttonText:  AppLocalizations.of(context).translate('yes'),
              callback: (c) {
               Navigator.of(context).popUntil((route) => route.isFirst);
                ScreenState state = Provider.of<ScreenState>(context, listen: false);
                state.reset();
              },
            ),
            Button(
                 popUpButton: true,
                 buttonText: AppLocalizations.of(context).translate('no'),
                 callback: (c) {
                   SystemNavigator.pop();
                 }),
          ],
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  static Future getGeneralDialog(
      BuildContext context, String prizeMoney, String titleText) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.6),
        transitionBuilder: (context, a1, a2, widget) {
         final curvedValue = Curves.easeIn.transform(a1.value) - 1.0;

          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: _getSimpleDialog(context, prizeMoney, titleText),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: false,
        context: context,
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {});
  }

  static bool isEnglish(Locale locale) {
    return locale.languageCode == english;
  }
}
