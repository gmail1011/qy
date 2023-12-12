import 'package:fish_redux/fish_redux.dart';

import 'entry_history_action.dart';
import 'entry_history_state.dart';

Reducer<EntryHistoryState> buildReducer() {
  return asReducer(
    <Object, Reducer<EntryHistoryState>>{
      EntryHistoryAction.action: _onAction,
      EntryHistoryAction.initData: _onInitData,
      EntryHistoryAction.onLoadMore: _onLoadMore,
    },
  );
}

EntryHistoryState _onAction(EntryHistoryState state, Action action) {
  final EntryHistoryState newState = state.clone();
  return newState;
}

EntryHistoryState _onInitData(EntryHistoryState state, Action action) {
  final EntryHistoryState newState = state.clone();
  newState.entryHistoryData = action.payload;
  return newState;
}

EntryHistoryState _onLoadMore(EntryHistoryState state, Action action) {
  final EntryHistoryState newState = state.clone();
  newState.pageNumber = action.payload;
  return newState;
}
