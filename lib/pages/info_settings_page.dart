import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../application.dart';
import '../bloc/login_bloc.dart';
import '../entities/user_entity.dart';
import '../locale/app_localizations.dart';
import '../pages/setting_page.dart';
import '../resource.dart';
import '../routers/routers.dart';
import '../utils/database_utils.dart';
import '../utils/preference_utils.dart';

class InfoSettingsPage extends StatefulWidget {
  final int userId;

  InfoSettingsPage({Key key, @required this.userId}) : super(key: key);

  @override
  _InfoSettingsPageState createState() => _InfoSettingsPageState();
}

class _InfoSettingsPageState extends State<InfoSettingsPage> {
  User user;
  var _currentAva = '';

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  _initUser() async {
    var temp = await DatabaseUtil.instance.getUserById(widget.userId);
    var fileExits = await File(temp.avatarPath).exists();
    setState(() {
      user = temp;
      if (fileExits) {
        _currentAva = temp.avatarPath;
      } else
        _currentAva = '';
    });
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

  void _selectImage() async {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              alignment: Alignment.center,
              height: 122.0,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  InkWell(
                      child: Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          width: MediaQuery.of(context).size.width,
                          child: Text(AppLocalizations.of(context).text('from_camera'))),
                      onTap: () async {
                        var image = await ImagePicker.pickImage(source: ImageSource.camera);
                        setState(() {
                          if (image != null) {
                            _currentAva = image.absolute.path;
                            DatabaseUtil.instance.updateAvatar(user.id, _currentAva);
                          }
                        });
                        Navigator.of(context).pop();
                      }),
                  Divider(height: 1.0, color: Theme.of(context).primaryColorDark),
                  InkWell(
                      child: Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          width: MediaQuery.of(context).size.width,
                          child: Text(AppLocalizations.of(context).text('from_gallery'))),
                      onTap: () async {
                        var image = await ImagePicker.pickVideo(source: ImageSource.gallery);
                        setState(() {
                          if (image != null) {
                            _currentAva = image.absolute.path;
                            DatabaseUtil.instance.updateAvatar(user.id, _currentAva);
                          }
                        });
                        Navigator.of(context).pop();
                      }),
                  Divider(height: 1.0, color: Theme.of(context).primaryColorDark),
                  InkWell(
                      child: Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          width: MediaQuery.of(context).size.width,
                          child: Text(AppLocalizations.of(context).text('cancel'))),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                ],
              ),
            ));
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
                      ? Container(alignment: Alignment.center, child: CupertinoActivityIndicator(radius: 12.0))
                      : SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                  child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Hero(
                                        tag: 'Avatar',
                                        child: ClipOval(
                                            child: _currentAva.isEmpty
                                                ? Image.asset(Resource.imageAvaDefault,
                                                    width: 80.0, height: 80.0, fit: BoxFit.cover)
                                                : Image.file(File(_currentAva),
                                                    width: 80.0, height: 80.0, fit: BoxFit.cover)),
                                      )),
                                  onTap: _selectImage),
                              PersonalActionMenu(
                                  icon: MovieIcons.nickname,
                                  title: AppLocalizations.of(context).text('username'),
                                  color: color,
                                  value: user.username,
                                  action: () {
                                    Application.router
                                        .navigateTo(context, Routers.generateRenamePath(widget.userId),
                                            transition: TransitionType.fadeIn)
                                        .then((v) {
                                      if (v) Navigator.of(context).pop(true);
                                    });
                                  }),
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
                                                        maximumDate: DateTime.now(),
                                                      ))),
                                                ))
                                        : showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now())
                                            .then((date) {
                                            _updateBirthday(date);
                                          });
                                  }),
                              PersonalActionMenu(
                                  icon: MovieIcons.change_pass,
                                  title: AppLocalizations.of(context).text('password'),
                                  color: color,
                                  value: '',
                                  action: () {}),
                              PersonalActionMenu(
                                  icon: MovieIcons.login_out,
                                  title: AppLocalizations.of(context).text("login_out"),
                                  color: color,
                                  value: '',
                                  action: () {
                                    PreferencesUtil.saveString(Application.username, '');
                                    Application.loginBloc.dispatch(LoginEvent(LoginState.empty()));
                                    Navigator.of(context).pop();
                                  })
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
