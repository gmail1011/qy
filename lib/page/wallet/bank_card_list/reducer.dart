import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BankCardListState> buildReducer() {
  return asReducer(
    <Object, Reducer<BankCardListState>>{
      BankCardListAction.onUpdateData: _onUpdateData,
      BankCardListAction.updateUI: _updateUI,

    },
  );
}

BankCardListState _onUpdateData(BankCardListState state, Action action) {
  final BankCardListState newState = state.clone();
  newState.model = action.payload;
  return newState;
}

BankCardListState _updateUI(BankCardListState state, Action action) {
  final BankCardListState newState = state.clone();
  return newState;
}
