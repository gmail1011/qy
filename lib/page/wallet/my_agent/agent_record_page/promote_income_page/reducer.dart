import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PromoteIncomeState> buildReducer() {
  return asReducer(
    <Object, Reducer<PromoteIncomeState>>{
      PromoteIncomeAction.setLoadData: _setLoadData,
      PromoteIncomeAction.setMoreLoadData: _setMoreLoadData,
    },
  );
}

PromoteIncomeState _setLoadData(PromoteIncomeState state, Action action) {
  final PromoteIncomeState newState = state.clone();
  newState.model = action.payload;
  newState.pageNumber = 1;
  newState.inviteIncomeList = newState.model?.inviteItemList ?? [];
  return newState;
}

PromoteIncomeState _setMoreLoadData(PromoteIncomeState state, Action action) {
  final PromoteIncomeState newState = state.clone();

  newState.pageNumber++;
  newState.inviteIncomeList.addAll(action.payload);
  return newState;
}
