import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application.dart';
import '../locale/app_localizations.dart';
import '../resource.dart';
import '../routers/routers.dart';

typedef void MenuAction();

class SettingPage extends StatelessWidget {
  final title;

  SettingPage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: Application.themeBloc,
        builder: (context, color) {
          return BlocBuilder(
              bloc: Application.loginBloc,
              builder: (context, user) {
                return Scaffold(
                  appBar: AppBar(
                      title: Text(AppLocalizations.of(context).text('home_title'),
                          style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: Resource.fontFamilyDancingScript,
                          ))),
                  body: Container(
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        InkWell(
                            child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Hero(
                                    tag: 'Avatar',
                                    child: ClipOval(
                                        child: user == null
                                            ? Image.asset(Resource.imageAvaDefault, width: 80.0, height: 80.0)
                                            : Image.file(File(user.avatarPath), width: 80.0, height: 80.0)))),
                            onTap: () {
                              Application.router
                                  .navigateTo(context, '${Routers.login}', transition: TransitionType.fadeIn);
                            }),
                        SettingMenu(
                            icon: MovieIcons.theme,
                            title: AppLocalizations.of(context).text('theme'),
                            color: color,
                            action: () {
                              Application.router
                                  .navigateTo(context, Routers.appTheme, transition: TransitionType.fadeIn);
                            })
                      ],
                    ),
                  ),
                );
              });
        });
  }
}

class SettingMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final MenuAction action;

  SettingMenu({Key key, @required this.icon, @required this.title, @required this.color, @required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          height: 50.0,
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Icon(icon, color: color, size: 28.0),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(title, style: TextStyle(color: color, fontSize: 18.0)),
                )),
                Icon(Icons.keyboard_arrow_right)
              ])),
        ),
        onTap: action);
  }
}
