import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<GameIncomeRecordState> buildReducer() {
  return asReducer(
    <Object, Reducer<GameIncomeRecordState>>{
      GameIncomeRecordAction.action: _onAction,
      GameIncomeRecordAction.refreshData: _refreshData,
      GameIncomeRecordAction.setLoadData: _setLoadData,
      GameIncomeRecordAction.setMoreData: _setMoreData,
    },
  );
}

GameIncomeRecordState _onAction(GameIncomeRecordState state, Action action) {
  final GameIncomeRecordState newState = state.clone();
  return newState;
}

GameIncomeRecordState _refreshData(GameIncomeRecordState state, Action action) {
  final GameIncomeRecordState newState = state.clone();
  newState.userIncomeModel = action.payload;
  return newState;
}

GameIncomeRecordState _setLoadData(GameIncomeRecordState state, Action action) {
  final GameIncomeRecordState newState = state.clone();
  newState.gamePromotionData = action.payload;
  newState.pageNumber = 1;
  newState.dataList = newState.gamePromotionData?.xList ?? [];
  return newState;
}

GameIncomeRecordState _setMoreData(GameIncomeRecordState state, Action action) {
  final GameIncomeRecordState newState = state.clone();
  newState.dataList.addAll(action.payload.xList ?? []);
  newState.pageNumber++;
  return newState;
}
