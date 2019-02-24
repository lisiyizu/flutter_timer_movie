import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_movie/application.dart';
import 'package:flutter_timer_movie/bloc/theme_bloc.dart';
import 'package:flutter_timer_movie/routers/routers.dart';
import 'package:flutter_timer_movie/utils/preference_utils.dart';

class MovieApp extends StatefulWidget {
  @override
  _MovieAppState createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  _MovieAppState() {
    final router = Router();
    Routers.configureRouters(router);
    Application.router = router;
    _initThemeColor();
  }

  _initThemeColor() async {
    int index = await PreferencesUtil.restoreInteger(Application.themeIndexKey, defaultValue: 0);
    var bloc = ThemeBloc(Application.themeColors[index]);
    Application.themeBloc = bloc;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimerMovie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      onGenerateRoute: Application.router.generator,
    );
  }
}
