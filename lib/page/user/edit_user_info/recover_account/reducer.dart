import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<RecoverAccountState> buildReducer() {
  return asReducer(
    <Object, Reducer<RecoverAccountState>>{
      RecoverAccountAction.updateUI: _updateUI,
      RecoverAccountAction.changeSelectType: _changeSelectType,
    },
  );
}

RecoverAccountState _changeSelectType(
    RecoverAccountState state, Action action) {
  final RecoverAccountState newState = state.clone();
  newState.selectType = action.payload as int;
  return newState;
}

RecoverAccountState _updateUI(RecoverAccountState state, Action action) {
  final RecoverAccountState newState = state.clone();
  return newState;
}
