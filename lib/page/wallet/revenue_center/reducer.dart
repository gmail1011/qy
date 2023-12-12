import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<RevenueCenterState> buildReducer() {
  return asReducer(
    <Object, Reducer<RevenueCenterState>>{
      RevenueCenterAction.updateUI: _updateUI,
    },
  );
}

RevenueCenterState _updateUI(RevenueCenterState state, Action action) {
  final RevenueCenterState newState = state.clone();
  return newState;
}
