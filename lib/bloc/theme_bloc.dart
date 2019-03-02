import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeEvent {
  Color _themeColor;

  ThemeEvent(this._themeColor);

  Color get themeColor => _themeColor;
}

class ThemeBloc extends Bloc<ThemeEvent, Color> {
  Color initColor;

  ThemeBloc(this.initColor);

  @override
  Color get initialState => initColor;

  @override
  Stream<Color> mapEventToState(Color currentState, ThemeEvent event) async* {
    yield event.themeColor;
  }
}
