import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../application.dart';
import '../locale/app_localizations.dart';
import '../resource.dart';
import '../utils/database_utils.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmController = TextEditingController();
  var _registerKey = GlobalKey<FormState>();
  var _currentAva = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
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
                          if (image != null) _currentAva = image.absolute.path;
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
                          if (image != null) _currentAva = image.absolute.path;
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

  void _register() async {
    if (_registerKey.currentState.validate()) {
      var username = _usernameController.text;
      var password = _passwordController.text;
      FocusScope.of(context).requestFocus(FocusNode());
      var exits = await DatabaseUtil.instance.isUserExists(username);

      if (exits) {
        Fluttertoast.showToast(msg: AppLocalizations.of(context).text('user_has_exits'));
        setState(() {
          _usernameController.text = '';
          _passwordController.text = '';
          _confirmController.text = '';
        });
      } else {
        var value = await DatabaseUtil.instance.insertUserIntoDb(username, password, _currentAva);
        if (value > 0) {
          Fluttertoast.showToast(msg: AppLocalizations.of(context).text('register_succeed'));
          Navigator.of(context).pop();
        } else {
          Fluttertoast.showToast(msg: AppLocalizations.of(context).text('register_fail'));
        }
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
                centerTitle: true,
                title: Text(AppLocalizations.of(context).text('register')),
              ),
              body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                              child: Hero(
                                  tag: 'Avatar',
                                  child: ClipOval(
                                      child: _currentAva.isEmpty
                                          ? Image.asset(Resource.imageAvaDefault,
                                              width: 80.0, height: 80.0, fit: BoxFit.cover)
                                          : Image.file(File(_currentAva),
                                              width: 80.0, height: 80.0, fit: BoxFit.cover))),
                              onTap: _selectImage),

                          ///
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Form(
                                key: _registerKey,
                                child: Column(children: <Widget>[
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
                                          prefixIcon: Icon(Icons.lock_outline),
                                          labelText: AppLocalizations.of(context).text('password'),
                                          hintText: AppLocalizations.of(context).text('password_hint')),
                                      validator: (value) => value.trim().length < 6
                                          ? AppLocalizations.of(context).text('password_error')
                                          : null),
                                  TextFormField(
                                      obscureText: true,
                                      controller: _confirmController,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock),
                                          labelText: AppLocalizations.of(context).text('confirm_info'),
                                          hintText: AppLocalizations.of(context).text('conform_hint')),
                                      validator: (value) =>
                                          value.trim() != null && value.trim() == _passwordController.text
                                              ? null
                                              : AppLocalizations.of(context).text('conform_error')),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      child: Container(
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                            color: color,
                                            onPressed: _register,
                                            child: Text(AppLocalizations.of(context).text('register'),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.white, fontSize: 18.0)),
                                          ),
                                          width: MediaQuery.of(context).size.width))
                                ])),
                          )
                        ],
                      ),
                    )),
              ),
            )));
  }
}
