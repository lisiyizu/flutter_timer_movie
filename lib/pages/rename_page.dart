import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../application.dart';
import '../locale/app_localizations.dart';
import '../resource.dart';
import '../utils/database_utils.dart';

class RenamePage extends StatefulWidget {
  final int userId;

  RenamePage({Key key, @required this.userId}) : super(key: key);

  @override
  _RenamePageState createState() => _RenamePageState();
}

class _RenamePageState extends State<RenamePage> {
  TextEditingController _textController;
  var _formKey = GlobalKey<FormState>();
  var username = '';

  @override
  void initState() {
    super.initState();

    _initUserInfo();
  }

  _initUserInfo() async {
    DatabaseUtil.instance.getUserById(widget.userId).then((user) {
      setState(() {
        username = user.username;
        _textController = TextEditingController(text: username);
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  _save() async {
    if (_formKey.currentState.validate()) {
      var newNick = _textController.text;
      if (newNick == username) {
        Navigator.of(context).pop(false);
      } else {
        var exits = await DatabaseUtil.instance.isUserExists(newNick);
        if (exits) {
          Fluttertoast.showToast(msg: AppLocalizations.of(context).text('user_has_exits'));
          setState(() => _textController.text = '');
        } else {
          FocusScope.of(context).requestFocus(FocusNode());
          DatabaseUtil.instance.updateUsername(widget.userId, newNick);
          Navigator.of(context).pop(true);
        }
      }
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
                  title: Text(AppLocalizations.of(context).text("rename")),
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
                  ]),
              body: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Form(
                      key: _formKey,
                      child: TextFormField(
                        autofocus: true,
                        controller: _textController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(MovieIcons.nickname),
                            labelText: AppLocalizations.of(context).text('username'),
                            hintText: AppLocalizations.of(context).text('username_hint')),
                        validator: (value) =>
                            value.trim().isEmpty ? AppLocalizations.of(context).text('username_error') : null,
                      ))),
            )));
  }
}
