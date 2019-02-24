import 'package:bloc/bloc.dart';

class CityEvent {}

class CityBloc extends Bloc<CityEvent, int> {
  @override
  int get initialState => 290;

  @override
  Stream<int> mapEventToState(int currentState, CityEvent event) async* {
    yield null;
  }
}
