import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppLocalizations {
  Locale locale;
  static Map<String, dynamic> _localeValues;

  AppLocalizations(this.locale);

  String text(String key) => _localeValues[key] ?? '** $key not found';

  static AppLocalizations of(BuildContext context) => Localizations.of(context, AppLocalizations);

  static Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    String content = await rootBundle.loadString('locale/i18n_${locale.languageCode}.json');
    _localeValues = json.decode(content);
    return SynchronousFuture(localizations);
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  static AppLocalizationsDelegate delegate = const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
