import 'package:fish_redux/fish_redux.dart';

class NoNetState implements Cloneable<NoNetState> {

  @override
  NoNetState clone() {
    return NoNetState();
  }
}

NoNetState initState(Map<String, dynamic> args) {
  return NoNetState();
}
