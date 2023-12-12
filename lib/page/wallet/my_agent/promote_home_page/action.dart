import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum PromoteHomeAction { action }

class PromoteHomeActionCreator {
  static Action onAction() {
    return const Action(PromoteHomeAction.action);
  }
}
