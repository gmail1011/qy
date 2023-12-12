import 'package:fish_redux/fish_redux.dart';

enum MineLikeAction { action }

class MineLikeActionCreator {
  static Action onAction() {
    return const Action(MineLikeAction.action);
  }
}
