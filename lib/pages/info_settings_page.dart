import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application.dart';
import '../entities/user_entity.dart';
import '../locale/app_localizations.dart';
import '../pages/setting_page.dart';
import '../resource.dart';
import '../utils/database_utils.dart';

class InfoSettingsPage extends StatefulWidget {
  final String username;

  InfoSettingsPage({Key key, @required this.username}) : super(key: key);

  @override
  _InfoSettingsPageState createState() => _InfoSettingsPageState();
}

class _InfoSettingsPageState extends State<InfoSettingsPage> {
  User user;

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  _initUser() async {
    var temp = await DatabaseUtil.instance.getUserByUsername(widget.username);
    setState(() => user = temp);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _updateBirthday(DateTime date) async {
    DatabaseUtil.instance.updateBirthday(user.id, '${date.year}-${date.month}-${date.day}').then((int) {
      DatabaseUtil.instance.getUserById(user.id).then((temp) {
        setState(() => user = temp);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _genderItems = [
      AppLocalizations.of(context).text('gender_men'),
      AppLocalizations.of(context).text('gender_women')
    ];

    return BlocBuilder(
        bloc: Application.themeBloc,
        builder: (context, Color color) => Theme(
            data: ThemeData(primarySwatch: color, iconTheme: IconThemeData(color: color)),
            child: Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).text('personal_settings')),
              ),
              body: Container(
                  child: user == null
                      ? CupertinoActivityIndicator(radius: 12.0)
                      : SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                  child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Hero(
                                        tag: 'Avatar',
                                        child: ClipOval(
                                            child: user.avatarPath.isEmpty
                                                ? Image.asset(Resource.imageAvaDefault,
                                                    width: 80.0, height: 80.0, fit: BoxFit.cover)
                                                : Image.file(File(user.avatarPath),
                                                    width: 80.0, height: 80.0, fit: BoxFit.cover)),
                                      )),
                                  onTap: () {}),
                              PersonalActionMenu(
                                  icon: MovieIcons.nickname,
                                  title: AppLocalizations.of(context).text('username'),
                                  color: color,
                                  value: widget.username,
                                  action: () {}),
                              PersonalActionMenu(
                                  icon: MovieIcons.gender,
                                  title: AppLocalizations.of(context).text('gender'),
                                  color: color,
                                  value: AppLocalizations.of(context).text(user.gender == null
                                      ? 'unknown'
                                      : user.gender == 0 ? 'gender_men' : 'gender_women'),
                                  action: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Container(
                                              height: 150.0,
                                              child: CupertinoPicker.builder(
                                                backgroundColor: CupertinoColors.white,
                                                itemExtent: 50.0,
                                                onSelectedItemChanged: (index) {
                                                  DatabaseUtil.instance.updateGender(user.id, index).then((int) {
                                                    DatabaseUtil.instance.getUserById(user.id).then((temp) {
                                                      setState(() => user = temp);
                                                    });
                                                  });
                                                },
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                      alignment: Alignment.center, child: Text(_genderItems[index]));
                                                },
                                                childCount: _genderItems.length,
                                              ),
                                            ));
                                  }),
                              PersonalActionMenu(
                                  icon: MovieIcons.birthday,
                                  title: AppLocalizations.of(context).text('birthday'),
                                  color: color,
                                  value: user.birthday == null
                                      ? AppLocalizations.of(context).text('unknown')
                                      : user.birthday,
                                  action: () {
                                    Localizations.localeOf(context).languageCode == 'en'
                                        ? showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) => Container(
                                                  height: 250.0,
                                                  color: CupertinoColors.white,
                                                  child: DefaultTextStyle(
                                                      style: TextStyle(color: CupertinoColors.black, fontSize: 20.0),
                                                      child: SafeArea(

                                                          /// 目前只支持英文模式下的显示，flutter v1.1.9
                                                          child: CupertinoDatePicker(
                                                        use24hFormat: true,
                                                        mode: CupertinoDatePickerMode.date,
                                                        onDateTimeChanged: (date) {
                                                          _updateBirthday(date);
                                                        },
                                                        initialDateTime: DateTime.now(),
                                                        minimumDate: DateTime(1900),
                                                        maximumDate: DateTime(2099, 12, 31),
                                                      ))),
                                                ))
                                        : showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2099, 12, 31))
                                            .then((date) {
                                            _updateBirthday(date);
                                          });
                                  }),
                              PersonalActionMenu(
                                  icon: MovieIcons.change_pass,
                                  title: AppLocalizations.of(context).text('password'),
                                  color: color,
                                  value: '',
                                  action: () {})
                            ],
                          ),
                        )),
            )));
  }
}

class PersonalActionMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final MenuAction action;

  PersonalActionMenu(
      {Key key,
      @required this.icon,
      @required this.title,
      @required this.color,
      @required this.value,
      @required this.action})
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
                Icon(icon, color: color, size: 24.0),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(title, style: TextStyle(color: color, fontSize: 18.0)),
                )),
                Row(
                  children: <Widget>[
                    Text(value, style: TextStyle(color: color, fontSize: 18.0)),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                )
              ])),
        ),
        onTap: action);
  }
}
