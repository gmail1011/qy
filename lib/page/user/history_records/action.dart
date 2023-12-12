import 'package:fish_redux/fish_redux.dart';

enum HistoryRecordsAction { action, changeEditState, clearEditState }

class HistoryRecordsActionCreator {
  static Action onAction() {
    return const Action(HistoryRecordsAction.action);
  }

  static Action changeEditState(int index) {
    return Action(HistoryRecordsAction.changeEditState, payload: index);
  }

  static Action clearEditState(int index) {
    return Action(HistoryRecordsAction.clearEditState, payload: index);
  }
}
