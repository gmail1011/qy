import 'package:fish_redux/fish_redux.dart';

enum UserLikeAction { action }

class UserLIkeActionCreator {
  static Action onAction() {
    return const Action(UserLikeAction.action);
  }
}
