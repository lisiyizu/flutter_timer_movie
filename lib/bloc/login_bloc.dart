import 'dart:async';

import 'package:bloc/bloc.dart';

class LoginEvent {
  LoginState state;

  LoginEvent(this.state);
}

class LoginState {
  String username;
  String avaPath;

  LoginState(this.username, this.avaPath);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginState initState;

  LoginBloc(this.initState);

  @override
  LoginState get initialState => initState;

  @override
  Stream<LoginState> mapEventToState(LoginState currentState, LoginEvent event) async* {
    yield event.state;
  }
}
