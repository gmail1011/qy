import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum GamePageAction { action }

class GamePageActionCreator {
  static Action onAction() {
    return const Action(GamePageAction.action);
  }
}
