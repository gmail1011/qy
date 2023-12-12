import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PayForState> buildReducer() {
  return asReducer(
    <Object, Reducer<PayForState>>{
      PayForAction.isPaying: _loading,
      PayForAction.updatePayRadioType: _updatePayRadioType,
      PayForAction.selectTickets: _selectTickets,
      PayForAction.updateUI: _updateUI,
    },
  );
}

PayForState _updatePayRadioType(PayForState state, Action action) {
  final PayForState newState = state.clone();
  newState.payRadioType = action.payload;
  return newState;
}

PayForState _loading(PayForState state, Action action) {
  final PayForState newState = state.clone();
  newState.isPayLoading = action.payload;
  print("_loading-------------------------${newState.isPayLoading}");
  return newState;
}


PayForState _selectTickets(PayForState state, Action action) {
  final PayForState newState = state.clone();
  newState.selectTickets = action.payload;
  return newState;
}


PayForState _updateUI(PayForState state, Action action) {
  final PayForState newState = state.clone();
  return newState;
}
