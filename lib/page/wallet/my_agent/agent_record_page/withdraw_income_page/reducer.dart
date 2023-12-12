import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WithdrawIncomeState> buildReducer() {
  return asReducer(
    <Object, Reducer<WithdrawIncomeState>>{
      WithdrawIncomeAction.setLoadData: _setLoadData,
      WithdrawIncomeAction.setLoadMoreData: _setLoadMoreData,
    },
  );
}

WithdrawIncomeState _setLoadData(WithdrawIncomeState state, Action action) {
  final WithdrawIncomeState newState = state.clone();
  newState.listData = action.payload;
  newState.pageNumber = 1;
  return newState;
}

WithdrawIncomeState _setLoadMoreData(WithdrawIncomeState state, Action action) {
  final WithdrawIncomeState newState = state.clone();
  newState.listData.addAll(action.payload);
  newState.pageNumber++;
  return newState;
}
