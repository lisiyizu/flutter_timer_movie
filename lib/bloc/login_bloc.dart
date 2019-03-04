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

  LoginState(this.username, this.avaPath, this.hasLogin);

  LoginState.empty()
      : this.username = '',
        this.avaPath = '',
        this.hasLogin = false;

  LoginState.login(String username, String avaPath)
      : this.username = username,
        this.avaPath = avaPath,
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
