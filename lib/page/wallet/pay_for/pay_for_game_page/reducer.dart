import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PayForGameState> buildReducer() {
  return asReducer(
    <Object, Reducer<PayForGameState>>{
      PayForGameAction.isPaying: _loading,
      PayForGameAction.updatePayRadioType: _updatePayRadioType,
    },
  );
}

// PayForGameState _onAction(PayForGameState state, Action action) {
//   final PayForGameState newState = state.clone();
//   return newState;
// }

PayForGameState _loading(PayForGameState state, Action action) {
  final PayForGameState newState = state.clone();
  newState.isPayLoading = action.payload;
  print("_loading-------------------------${newState.isPayLoading}");
  return newState;
}

PayForGameState _updatePayRadioType(PayForGameState state, Action action) {
  final PayForGameState newState = state.clone();
  newState.payRadioType = action.payload;
  return newState;
}
