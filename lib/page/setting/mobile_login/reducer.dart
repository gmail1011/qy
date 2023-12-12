import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MobileLoginState> buildReducer() {
  return asReducer(
    <Object, Reducer<MobileLoginState>>{
      MobileLoginAction.onGetSMSCodeAction: _onGetSMSCode,
      MobileLoginAction.onPhoneLoginAction: _onLogin,
      MobileLoginAction.onShowArea: _onShowArea,
    },
  );
}

MobileLoginState _onGetSMSCode(MobileLoginState state, Action action) {
  final MobileLoginState newState = state.clone()..getSMSCodeSuccess = action.payload;
  return newState;
}

MobileLoginState _onLogin(MobileLoginState state, Action action) {
  final MobileLoginState newState = state.clone()..isLogging = false;
  return newState;
}

//展示area code
MobileLoginState _onShowArea(MobileLoginState state, Action action) {
  final MobileLoginState newState = state.clone()..areaCode = action.payload;
  return newState;
}
