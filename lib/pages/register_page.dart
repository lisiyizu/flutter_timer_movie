import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application.dart';
import '../locale/app_localizations.dart';
import '../resource.dart';

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
//                        var image = await ImagePicker.pickImage(source: ImageSource.camera);
//                        setState(() {
//                          if (image != null) _currentAva = image.absolute.path;
//                        });
                      }),
                  Divider(height: 1.0, color: Theme.of(context).primaryColorDark),
                  InkWell(
                      child: Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          width: MediaQuery.of(context).size.width,
                          child: Text(AppLocalizations.of(context).text('from_gallery'))),
                      onTap: () async {
//                        var image = await ImagePicker.pickVideo(source: ImageSource.gallery);
//                        setState(() {
//                          if (image != null) _currentAva = image.absolute.path;
//                        });
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
                                          ? Image.asset(Resource.imageAvaDefault, width: 80.0, height: 80.0)
                                          : Image.file(File(_currentAva), width: 80.0, height: 80.0))),
                              onTap: _selectImage),

                          ///
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Form(child: Column(children: <Widget>[])),
                          )
                        ],
                      ),
                    )),
              ),
            )));
  }
}
