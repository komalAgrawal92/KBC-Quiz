import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kbc_quiz/app_localizations.dart';
import 'package:kbc_quiz/provider/screen_state.dart';
import 'package:kbc_quiz/screen/menu_screen.dart';
import 'package:kbc_quiz/util/play_audio.dart';
import 'package:kbc_quiz/util/util.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
    print("mainscreen_init");
    WidgetsBinding.instance.addObserver(this);

    this._fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        this.locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    PlayAudio(context: context);
    return ChangeNotifierProvider(
      create: (context) => ScreenState(),
      child: RateMyAppBuilder(
        builder:(context) => MaterialApp(

          debugShowCheckedModeBanner: false,
        supportedLocales: [
          const Locale('en', 'UK'),
          const Locale('hi', 'IN'),
        ],
        locale: locale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for(var supportedLocale in supportedLocales) {
            if(supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
          theme: ThemeData(
            buttonColor: Color(0xFF061D95),
            textSelectionColor: Colors.white,
            primaryColor: Color(0xFF1e2a78),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            accentColor: Color(0xFFFEF9EB),
          ),
          home: MenuScreen(),
      ),
      ),
    );
  }

  Future<Locale> _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    bool isEnglish = prefs.getBool(Util.locale) ?? true;
    prefs.setBool(Util.locale, isEnglish);
    Locale locale = isEnglish ? Locale('en', 'UK') : Locale('hi', 'IN');
    return locale;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused) {
      PlayAudio().pause();
    } else if(state == AppLifecycleState.resumed) {
      PlayAudio().resume();
    } else if(state == AppLifecycleState.detached) {
      PlayAudio().stopAll();
    } else if(state == AppLifecycleState.inactive) {
      PlayAudio().stopAll();
    }
  }

}
