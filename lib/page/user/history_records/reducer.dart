import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HistoryRecordsState> buildReducer() {
  return asReducer(
    <Object, Reducer<HistoryRecordsState>>{
      HistoryRecordsAction.action: _onAction,
    },
  );
}

HistoryRecordsState _onAction(HistoryRecordsState state, Action action) {
  final HistoryRecordsState newState = state.clone();
  return newState;
}
