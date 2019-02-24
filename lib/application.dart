import 'package:fluro/fluro.dart';
import 'package:flutter_timer_movie/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';

class Application {
  static var themeIndexKey = 'theme_index';
  static Router router;
  static ThemeBloc themeBloc;
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
