import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<RecoverMobileState> buildReducer() {
  return asReducer(
    <Object, Reducer<RecoverMobileState>>{
      RecoverMobileAction.action: _onAction,
      RecoverMobileAction.updateMobileText: _updateMobileText,
    },
  );
}

RecoverMobileState _updateMobileText(RecoverMobileState state, Action action) {
  final RecoverMobileState newState = state.clone();
  newState.mobileEditingController.text = action.payload as String;
  return newState;
}

RecoverMobileState _onAction(RecoverMobileState state, Action action) {
  final RecoverMobileState newState = state.clone();
  return newState;
}
