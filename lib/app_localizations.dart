import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _localeStrings;

  AppLocalizations(this.locale);

  static const _AppLocalizationsDelegate delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
      return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Future<bool> load({Locale l}) async {
      String jsonString =  l!= null ? await rootBundle.loadString('assets/json/constants/${l}.json')
                              : await rootBundle.loadString('assets/json/constants/${locale}.json');
      Map<String, dynamic> jsonMap =  json.decode(jsonString);
      _localeStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
     return true;
  }

  String translate(String key) {
    return _localeStrings[key];
  }

}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async{
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
  const _AppLocalizationsDelegate();

}