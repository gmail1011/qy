import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum loufengAction { action,updateLoading }

class loufengActionCreator {
  static Action onAction() {
    return const Action(loufengAction.action);
  }
  static Action updateLoading() {
    return const Action(loufengAction.updateLoading);
  }
}
