import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum GameRulesAction { action }

class GameRulesActionCreator {
  static Action onAction() {
    return const Action(GameRulesAction.action);
  }
}
