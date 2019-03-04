import 'dart:async';
import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../application.dart';
import '../bloc/login_bloc.dart';
import '../locale/app_localizations.dart';
import '../resource.dart';
import '../routers/routers.dart';
import '../utils/database_utils.dart';
import '../utils/preference_utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _loginKey = GlobalKey<FormState>();
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _avatar = '';
  var _lastValue = '';

  @override
  void initState() {
    super.initState();

    // 监听用户名变化，修改头像
    _usernameController.addListener(() {
      _lastValue = _usernameController.text;
      Future.delayed(Duration(milliseconds: 300)).then((_) async {
        var value = _usernameController.text;
        if (value.isNotEmpty && value == _lastValue) {
          var user = await DatabaseUtil.instance.getUserByUsername(value);
          if (user != null) {
            setState(() => _avatar = user.avatarPath);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    // 表单是否有效
    if (_loginKey.currentState.validate()) {
      var username = _usernameController.text;
      var password = _passwordController.text;
      FocusScope.of(context).requestFocus(FocusNode());

      // 是否存在该用户名
      var exits = await DatabaseUtil.instance.isUserExists(username);
      var id = await DatabaseUtil.instance.isUserValidate(username, password);

      if (!exits) {
        setState(() => _passwordController.text = '');
        Fluttertoast.showToast(msg: AppLocalizations.of(context).text('user_not_exits'));
      } else if (id > 0) {
        Fluttertoast.showToast(msg: AppLocalizations.of(context).text('login_succeed'));
        PreferencesUtil.saveString(Application.username, username);
        DatabaseUtil.instance.getUserByUsername(username).then((user) {
          Application.loginBloc.dispatch(LoginEvent(LoginState.login(user.username, user.avatarPath)));
          Navigator.of(context).pop();
        });
      } else {
        Fluttertoast.showToast(msg: AppLocalizations.of(context).text('not_match'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: Application.themeBloc,
        builder: (context, color) => Theme(
            data: ThemeData(primarySwatch: color, iconTheme: IconThemeData(color: color)),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(icon: Icon(Icons.close, size: 28.0), onPressed: () => Navigator.pop(context)),
                centerTitle: true,
                title: Text(AppLocalizations.of(context).text('login')),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(MovieIcons.register),
                      tooltip: AppLocalizations.of(context).text('register'),
                      onPressed: () {
                        Application.router.navigateTo(context, Routers.register, transition: TransitionType.fadeIn);
                      })
                ],
              ),
              body: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ///
                          Hero(
                              tag: 'Avatar',
                              child: ClipOval(
                                  child: _avatar.isEmpty
                                      ? Image.asset(Resource.imageAvaDefault,
                                          width: 80.0, height: 80.0, fit: BoxFit.cover)
                                      : Image.file(File(_avatar), width: 80.0, height: 80.0, fit: BoxFit.cover))),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Form(
                                key: _loginKey,

                                ///
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.person),
                                            labelText: AppLocalizations.of(context).text('username'),
                                            hintText: AppLocalizations.of(context).text('username_hint')),
                                        validator: (value) => value.trim().isEmpty
                                            ? AppLocalizations.of(context).text('username_error')
                                            : null),
                                    TextFormField(
                                        obscureText: true,
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.lock),
                                            labelText: AppLocalizations.of(context).text('password'),
                                            hintText: AppLocalizations.of(context).text('password_hint')),
                                        validator: (value) => value.trim().length < 6
                                            ? AppLocalizations.of(context).text('password_error')
                                            : null),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                        child: Container(
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                              color: color,
                                              onPressed: _login,
                                              child: Text(AppLocalizations.of(context).text('login'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.white, fontSize: 18.0)),
                                            ),
                                            width: MediaQuery.of(context).size.width))
                                  ],
                                )),
                          )
                        ],
                      ),
                    )),
              ),
            )));
  }
}
