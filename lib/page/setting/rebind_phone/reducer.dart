import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<RebindPhoneState> buildReducer() {
  return asReducer(
    <Object, Reducer<RebindPhoneState>>{
      RebindPhoneAction.onGetSMSCodeAction: _onGetSMSCode,
      RebindPhoneAction.onBindPhoneAction: _onBind,
      RebindPhoneAction.onRefreshState: _onRefreshState,
    },
  );
}

RebindPhoneState _onGetSMSCode(RebindPhoneState state, Action action) {
  final RebindPhoneState newState = state.clone()..getSMSCodeSuccess = action.payload;
  return newState;
}

RebindPhoneState _onBind(RebindPhoneState state, Action action) {
  final RebindPhoneState newState = state.clone()..isBinding = false;
  return newState;
}
RebindPhoneState _onRefreshState(RebindPhoneState state, Action action) {
  final RebindPhoneState newState = state.clone();
  return newState;
}