import 'package:fish_redux/fish_redux.dart';

enum UserWorkAction { action }

class UserWorkActionCreator {
  static Action onAction() {
    return const Action(UserWorkAction.action);
  }
}
