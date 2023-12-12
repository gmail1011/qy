import 'package:fish_redux/fish_redux.dart';

enum UserBuyAction { action }

class UserBuyActionCreator {
  static Action onAction() {
    return const Action(UserBuyAction.action);
  }
}
