import 'package:fish_redux/fish_redux.dart';

class RecoverAccountState implements Cloneable<RecoverAccountState> {
  int selectType = 0;

  @override
  RecoverAccountState clone() {
    return RecoverAccountState()..selectType = selectType;
  }
}

RecoverAccountState initState(Map<String, dynamic> args) {
  return RecoverAccountState();
}
