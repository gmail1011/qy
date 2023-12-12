import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<RechargeHistoryState> buildReducer() {
  return asReducer(
    <Object, Reducer<RechargeHistoryState>>{
      RechargeHistoryAction.onRequestData: _onRequestData,
      RechargeHistoryAction.onError: _onError,
    },
  );
}

RechargeHistoryState _onRequestData(RechargeHistoryState state, Action action) {
  final RechargeHistoryState newState = state.clone();
  if (newState.list == null) {
    newState.list = [];
  }
  newState.list.addAll(action.payload);
  return newState;
}

RechargeHistoryState _onError(RechargeHistoryState state, Action action) {
  final RechargeHistoryState newState = state.clone();
  newState.errorMsg = action.payload;
  return newState;
}
