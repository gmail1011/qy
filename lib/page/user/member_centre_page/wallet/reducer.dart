import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WalletState> buildReducer() {
  return asReducer(
    <Object, Reducer<WalletState>>{
      WalletAction.updateUI: _updateUI,
      WalletAction.selectCurrentIndex: _selectCurrentIndex
    },
  );
}

WalletState _selectCurrentIndex(WalletState state, Action action) {
  final WalletState newState = state.clone();
  newState.selectIndex = action.payload;
  return newState;
}

WalletState _updateUI(WalletState state, Action action) {
  final WalletState newState = state.clone();
  return newState;
}
