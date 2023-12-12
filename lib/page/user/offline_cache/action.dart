import 'package:fish_redux/fish_redux.dart';

enum OfflineCacheAction { action, changeEditState, clearEditState }

class OfflineCacheActionCreator {
  static Action onAction() {
    return const Action(OfflineCacheAction.action);
  }

  static Action changeEditState(int index) {
    return Action(OfflineCacheAction.changeEditState, payload: index);
  }

  static Action clearEditState(int index) {
    return Action(OfflineCacheAction.clearEditState, payload: index);
  }
}
