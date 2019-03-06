import 'dart:async';

import 'package:bloc/bloc.dart';

class LoginEvent {
  LoginState state;

  LoginEvent(this.state);
}

class LoginState {
  String username;
  String avaPath;
  bool hasLogin;
  int userId;

  LoginState(this.username, this.avaPath, this.hasLogin, this.userId);

  LoginState.empty()
      : this.username = '',
        this.avaPath = '',
        this.hasLogin = false,
        this.userId = -1;

  LoginState.login(String username, String avaPath, int userId)
      : this.username = username,
        this.avaPath = avaPath,
        this.userId = userId,
        this.hasLogin = true;
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(LoginState currentState, LoginEvent event) async* {
    yield event.state;
  }
}
