import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Reducer<WithdrawDetailsState> buildReducer() {
  return asReducer(
    <Object, Reducer<WithdrawDetailsState>>{
      WithdrawDetailsAction.onRefreshData: _onRefreshData,
      WithdrawDetailsAction.onLoadData: _onLoadData,
      WithdrawDetailsAction.onError: _onError,
    },
  );
}

WithdrawDetailsState _onRefreshData(WithdrawDetailsState state, Action action) {
  final WithdrawDetailsState newState = state.clone();
  newState.model = action.payload;
  return newState;
}

WithdrawDetailsState _onLoadData(WithdrawDetailsState state, Action action) {
  final WithdrawDetailsState newState = state.clone();
  newState.model.hasNext = action.payload['hasNext'] ?? false;
  newState.model.list.addAll(action.payload["list"]);
  return newState;
}

WithdrawDetailsState _onError(WithdrawDetailsState state, Action action) {
  final WithdrawDetailsState newState = state.clone();
  newState.errorMsg = action.payload;
  return newState;
}