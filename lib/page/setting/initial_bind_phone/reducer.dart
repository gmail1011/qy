import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InitialBindPhoneState> buildReducer() {
  return asReducer(
    <Object, Reducer<InitialBindPhoneState>>{
      InitialBindPhoneAction.onSendSMSCodeAction: _onGetSMSCode,
      InitialBindPhoneAction.onBindPhoneAction: _onBind,
      InitialBindPhoneAction.onClickNextStepSuccess: _onClickNextStepSuccess,
      InitialBindPhoneAction.updateUI: _updateUI,
    },
  );
}

InitialBindPhoneState _onGetSMSCode(
    InitialBindPhoneState state, Action action) {
  final InitialBindPhoneState newState = state.clone()
    ..getSMSCodeSuccess = action.payload;
  return newState;
}

InitialBindPhoneState _onBind(InitialBindPhoneState state, Action action) {
  final InitialBindPhoneState newState = state.clone()..isBinding = false;
  return newState;
}

InitialBindPhoneState _onClickNextStepSuccess(
    InitialBindPhoneState state, Action action) {
  final InitialBindPhoneState newState = state.clone();
  return newState;
}

InitialBindPhoneState _updateUI(InitialBindPhoneState state, Action action) {
  final InitialBindPhoneState newState = state.clone();
  return newState;
}
