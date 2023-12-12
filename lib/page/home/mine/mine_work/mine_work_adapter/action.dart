import 'package:fish_redux/fish_redux.dart';

enum MineWorkAction {
  action,
}

class MineWorkAdapterActionCreator {
  static Action onAction() {
    return const Action(MineWorkAction.action);
  }
}
