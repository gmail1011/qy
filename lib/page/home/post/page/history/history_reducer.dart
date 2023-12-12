import 'package:fish_redux/fish_redux.dart';

import 'history_action.dart';
import 'history_state.dart';

Reducer<HistoryState> buildReducer() {
  return asReducer(
    <Object, Reducer<HistoryState>>{
      HistoryAction.action: _onAction,
      HistoryAction.initData: _onInitData,
      HistoryAction.loadMore: _onLoadMore,
    },
  );
}

HistoryState _onAction(HistoryState state, Action action) {
  final HistoryState newState = state.clone();
  return newState;
}

HistoryState _onInitData(HistoryState state, Action action) {
  final HistoryState newState = state.clone();
  newState.liaoBaHistoryData = action.payload;
  return newState;
}

HistoryState _onLoadMore(HistoryState state, Action action) {
  final HistoryState newState = state.clone();
  newState.pageNumber = action.payload;
  return newState;
}
