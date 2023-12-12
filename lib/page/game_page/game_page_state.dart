import 'package:fish_redux/fish_redux.dart';

class GamePageState implements Cloneable<GamePageState> {

  @override
  GamePageState clone() {
    return GamePageState();
  }
}

GamePageState initState(Map<String, dynamic> args) {
  return GamePageState();
}
