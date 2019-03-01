import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'bloc/login_bloc.dart';
import 'bloc/theme_bloc.dart';

class Application {
  static var themeIndexKey = 'theme_index';
  static var username = 'username_tag';
  static Router router;
  static ThemeBloc themeBloc;
  static LoginBloc loginBloc;
  static var themeColors = [
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.red,
    Colors.yellow,
    Colors.brown,
    Colors.cyan,
    Colors.deepOrange,
    Colors.purple,
    Colors.lightGreen,
    Colors.blueGrey,
    Colors.lime
  ];
}
