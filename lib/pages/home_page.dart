import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application.dart';
import '../locale/app_localizations.dart';
import '../pages/movie_page.dart';
import '../pages/setting_page.dart';
import '../resource.dart';
import '../utils/logger.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, @required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _logger = Logger('HomePage');
  var _pages = <Widget>[];
  var _index = 0;

  @override
  void initState() {
    super.initState();
    _pages..add(MoviePage(title: widget.title))..add(SettingPage(title: widget.title));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: BlocBuilder(
            bloc: Application.themeBloc,
            builder: (context, color) => Theme(
                  data: ThemeData(primarySwatch: color, iconTheme: IconThemeData(color: color)),
                  child: Scaffold(
                    body: IndexedStack(children: _pages, index: _index),
                    bottomNavigationBar: BottomNavigationBar(
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(MovieIcons.movie), title: Text(AppLocalizations.of(context).text('movie'))),
                        BottomNavigationBarItem(
                            icon: Icon(MovieIcons.person_settings),
                            title: Text(AppLocalizations.of(context).text('settings')))
                      ],
                      currentIndex: _index,
                      iconSize: 26.0,
                      type: BottomNavigationBarType.fixed,
                      onTap: (value) {
                        setState(() => _index = value);
                      },
                    ),
                  ),
                )),
        onWillPop: () {
          /// iOS 组件只能在 en 言语模式下启用 flutter v1.1.9
          if (Localizations.localeOf(context).languageCode == 'en') {
            showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                      content: Text(AppLocalizations.of(context).text('exit_content')),
                      actions: <Widget>[
                        CupertinoDialogAction(
                            child: Text(AppLocalizations.of(context).text('positive_button_hint')),
                            onPressed: () {
                              SystemNavigator.pop();
                              exit(0);
                            }),
                        CupertinoDialogAction(
                            child: Text(AppLocalizations.of(context).text('negative_button_hint')),
                            onPressed: () => Navigator.of(context).pop())
                      ],
                    ));
          } else {
            showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(content: Text(AppLocalizations.of(context).text('exit_content')), actions: <Widget>[
                      FlatButton(
                          child: Text(AppLocalizations.of(context).text('positive_button_hint')),
                          onPressed: () {
                            SystemNavigator.pop();
                            exit(0);
                          }),
                      FlatButton(
                          child: Text(AppLocalizations.of(context).text('negative_button_hint')),
                          onPressed: () => Navigator.of(context).pop())
                    ]));
          }
        });
  }
}
