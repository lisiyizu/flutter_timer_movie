import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_movie/application.dart';

class ThemeEvent {
  Color _themeColor;

  ThemeEvent(this._themeColor);

  Color get themeColor => _themeColor;
}

class ThemeBloc extends Bloc<ThemeEvent, Color> {
  @override
  Color get initialState => Application.themeColors[0];

  @override
  Stream<Color> mapEventToState(Color currentState, ThemeEvent event) async* {
    yield event.themeColor;
  }
}
