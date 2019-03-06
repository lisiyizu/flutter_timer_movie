import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'application.dart';
import 'bloc/login_bloc.dart';
import 'bloc/theme_bloc.dart';
import 'locale/app_localizations.dart';
import 'routers/routers.dart';
import 'utils/database_utils.dart';
import 'utils/preference_utils.dart';

class MovieApp extends StatefulWidget {
  @override
  _MovieAppState createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  @override
  void initState() {
    super.initState();

    final router = Router();
    Routers.configureRouters(router);
    Application.router = router;
    _initTheme();
    _initUser();
  }

  _initTheme() {
    Application.themeBloc = ThemeBloc();
    PreferencesUtil.restoreInteger(Application.themeIndexKey, defaultValue: 0).then((index) {
      Application.themeBloc.dispatch(ThemeEvent(Application.themeColors[index]));
    });
  }

  _initUser() {
    Application.loginBloc = LoginBloc();
    PreferencesUtil.restoreString(Application.username, defaultValue: '').then((username) {
      if (username.isNotEmpty)
        DatabaseUtil.instance.getUserByUsername(username).then((user) {
          Application.loginBloc.dispatch(LoginEvent(LoginState.login(user.username, user.avatarPath, user.id)));
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimerMovie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      onGenerateRoute: Application.router.generator,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        AppLocalizationsDelegate.delegate,
      ],
      supportedLocales: const <Locale>[const Locale('en'), const Locale('zh')],
    );
  }
}
