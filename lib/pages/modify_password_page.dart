import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../application.dart';
import '../locale/app_localizations.dart';
import '../utils/database_utils.dart';

class ModifyPasswordPage extends StatefulWidget {
  final int userId;

  ModifyPasswordPage({Key key, @required this.userId}) : super(key: key);

  @override
  _ModifyPasswordPageState createState() => _ModifyPasswordPageState();
}

class _ModifyPasswordPageState extends State<ModifyPasswordPage> {
  var _formKey = GlobalKey<FormState>();
  var _oldPasswordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _confirmedController = TextEditingController();
  var password = '';

  @override
  void initState() {
    super.initState();
    _getUserOldPassword();
  }

  _getUserOldPassword() async {
    DatabaseUtil.instance.getUserById(widget.userId).then((user) {
      setState(() => password = user.password);
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmedController.dispose();
    super.dispose();
  }

  _save() async {
    if (_formKey.currentState.validate()) {
      DatabaseUtil.instance.updatePassword(widget.userId, _newPasswordController.text).then((val) {
        if (val > 0) {
          Fluttertoast.showToast(msg: AppLocalizations.of(context).text('modify_succeed'));
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.of(context).pop(true);
        } else {
          Fluttertoast.showToast(msg: AppLocalizations.of(context).text('modify_succeed'));
          setState(() {
            _oldPasswordController.text = '';
            _newPasswordController.text = '';
            _confirmedController.text = '';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: Application.themeBloc,
        builder: (context, Color color) => Theme(
            data: ThemeData(primarySwatch: color, iconTheme: IconThemeData(color: color)),
            child: Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).text('change_pass')),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(icon: Icon(Icons.close, size: 28.0), onPressed: () => Navigator.pop(context)),
                actions: <Widget>[
                  InkWell(
                      onTap: _save,
                      child: Container(
                          child: Text(AppLocalizations.of(context).text("save"), style: TextStyle(fontSize: 16.0)),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0)))
                ],
              ),
              body: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    TextFormField(
                        obscureText: true,
                        controller: _oldPasswordController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            labelText: AppLocalizations.of(context).text('old_pass'),
                            hintText: AppLocalizations.of(context).text('old_pass_hint')),
                        validator: (value) =>
                            value.trim() != password ? AppLocalizations.of(context).text('old_pass_error') : null),
                    TextFormField(
                        obscureText: true,
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            labelText: AppLocalizations.of(context).text('new_pass'),
                            hintText: AppLocalizations.of(context).text('new_pass_hint')),
                        validator: (value) =>
                            value.trim().length < 6 ? AppLocalizations.of(context).text('password_error') : null),
                    TextFormField(
                        obscureText: true,
                        controller: _confirmedController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: AppLocalizations.of(context).text('new_pass_confirm'),
                            hintText: AppLocalizations.of(context).text('new_pass_confirm_hint')),
                        validator: (value) => value.trim() != null && value.trim() == _newPasswordController.text
                            ? null
                            : AppLocalizations.of(context).text('conform_error'))
                  ])),
            )));
  }
}
