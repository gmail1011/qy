import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MyIncomeState> buildReducer() {
  return asReducer(
    <Object, Reducer<MyIncomeState>>{
      MyIncomeAction.onRefreshData: _onRefreshData,
      MyIncomeAction.onLoadData: _onLoadData,
      MyIncomeAction.updateIncomeAction: _updateIncome,
    },
  );
}

MyIncomeState _onRefreshData(MyIncomeState state, Action action) {
  final MyIncomeState newState = state.clone();
  newState.model = action.payload;
  return newState;
}

MyIncomeState _updateIncome(MyIncomeState state, Action action) {
  final MyIncomeState newState = state.clone();
  newState.income = action.payload;
  return newState;
}

MyIncomeState _onLoadData(MyIncomeState state, Action action) {
  final MyIncomeState newState = state.clone();
  newState.model.list.addAll(action.payload['list']);
  newState.model.hasNext = action.payload['hasNext'] ?? false;
  return newState;
}
