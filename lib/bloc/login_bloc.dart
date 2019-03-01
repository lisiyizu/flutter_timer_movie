import 'package:bloc/bloc.dart';
import 'package:flutter_timer_movie/entities/user_entity.dart';

import '../application.dart';
import '../utils/database_utils.dart';
import '../utils/preference_utils.dart';

enum LoginEvent { Login, LoginOut }

class LoginBloc extends Bloc<LoginEvent, User> {
  User initUser;

  LoginBloc(this.initUser);

  @override
  User get initialState => initUser;

  @override
  Stream<User> mapEventToState(User currentState, LoginEvent event) async* {
    var username = await PreferencesUtil.restoreString(Application.username, defaultValue: '');
    var user = username.isEmpty ? null : await DatabaseUtil.instance.getUserByUsername(username);

    switch (event) {
      case LoginEvent.Login:
        yield user;
        break;
      case LoginEvent.LoginOut:
        yield null;
        break;
    }
  }
}
