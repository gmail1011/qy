import 'package:fish_redux/fish_redux.dart';

enum MineWorkItemAction { action }

class MineWorkItemActionCreator {
  static Action onAction() {
    return const Action(MineWorkItemAction.action);
  }
}
