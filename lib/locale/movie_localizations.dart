import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class MovieLocalizations extends DefaultMaterialLocalizations {
  Locale _locale;
  static Map<String, String> _localizedValues;

  MovieLocalizations(this._locale);

  String text(String key) => _localizedValues[key] ?? '$key missed';

  String get currentLanguageCode => _locale.languageCode;

  /// 国际化存在问题，调用 of 返回 null， 待解决
  static MovieLocalizations of(BuildContext context) => Localizations.of(context, MovieLocalizations);

  static Future<MovieLocalizations> load(Locale locale) async {
    var localizations = MovieLocalizations(locale);
    var jsonContent = await rootBundle.loadString('locale/i18n_${locale.languageCode}.json');
    _localizedValues = json.decode(jsonContent);
    return SynchronousFuture(localizations);
  }
}

class MovieLocalizationsDelegate extends LocalizationsDelegate<MovieLocalizations> {
  const MovieLocalizationsDelegate._internal();

  static MovieLocalizationsDelegate delegate = const MovieLocalizationsDelegate._internal();

  @override
  bool isSupported(Locale locale) => ['en, zh'].contains(locale.languageCode);

  @override
  Future<MovieLocalizations> load(Locale locale) => MovieLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<MovieLocalizations> old) => false;
}
