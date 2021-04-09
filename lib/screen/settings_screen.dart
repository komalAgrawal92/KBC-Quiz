import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbc_quiz/app_localizations.dart';
import 'package:kbc_quiz/util/play_audio.dart';
import 'package:kbc_quiz/util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Settings extends StatefulWidget {
  Settings({Key key, this.title, this.setLocale, this.isEnglish}) : super(key: key);
  final Function setLocale;
  final bool isEnglish;
  final String title;

  @override
  _SettingsState createState() => new _SettingsState(isEnglish);
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  bool _isSoundEnabled = PlayAudio().isSoundEnabled;
  SharedPreferences _prefs;
  bool _isEnglish;


  _SettingsState(this._isEnglish);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref().then((value) => _prefs = value);
  }

  @override
  Widget build(BuildContext context) {

    return SimpleDialog(
      contentPadding: EdgeInsets.all(30.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.settings),
       SizedBox(width: 10.0,),
       Text(
        AppLocalizations.of(context).translate("settings"),
        style: Util.getTextStyle(context).copyWith(
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.center,
      ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 10.0,
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate("sound") ,
                  style: GoogleFonts.mcLaren(fontSize: 20.0, letterSpacing: 1.1, color: Colors.white),
                ),
                Switch(
                  activeColor: Theme.of(context).iconTheme.color,
                  inactiveThumbColor: Colors.blueGrey,
                  value: _isSoundEnabled,
                  onChanged: (value) {
                    saveSoundSettings(value);
                    setState(() {
                      _isSoundEnabled = value;
                    });
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate("language"),
                  style: GoogleFonts.mcLaren(fontSize: 20.0, letterSpacing: 1.1, color: Colors.white),
                ),
                Switch(
                  activeColor: Theme.of(context).iconTheme.color,
                  inactiveThumbColor: Colors.blueGrey,
                  value: _isEnglish,
                  onChanged: (value) {
                    setState(() {
                      saveLocaleSettings(value, context);
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  saveSoundSettings(bool value) {
    PlayAudio().setVolume(value);
     _prefs.setBool("sound", value);
  }

  saveLocaleSettings(bool value, BuildContext context) {
    _isEnglish = value;
    widget.setLocale(value);
    _prefs.setBool(Util.locale, value);
    AppLocalizations.of(context).load(l :_isEnglish ? Locale('en', 'UK')  : Locale('hi', 'IN') );
  }

  Future<SharedPreferences> getPref() async{
    return await SharedPreferences.getInstance();
  }
}
