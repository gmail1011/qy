import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SwitchAccountState> buildReducer() {
  return asReducer(
    <Object, Reducer<SwitchAccountState>>{
      SwitchAccountAction.loadSwitchAccountAction: _onLoadSwitchAccount,
      // SwitchAccountAction.onDevLoginAction: _onDevLogin,
      SwitchAccountAction.localUserGetOkay: _onLocalUserGetOkay,
      SwitchAccountAction.onGetVersion: _onGetVersion,
      SwitchAccountAction.showLoading: _onShowLoading,
    },
  );
}

SwitchAccountState _onLocalUserGetOkay(
    SwitchAccountState state, Action action) {
  return state.clone()..localUserInfoList = action.payload;
}

SwitchAccountState _onShowLoading(SwitchAccountState state, Action action) {
  return state.clone()..showLoading = action.payload;
}

SwitchAccountState _onGetVersion(SwitchAccountState state, Action action) {
  final SwitchAccountState newState = state.clone();
  return newState;
}

SwitchAccountState _onLoadSwitchAccount(
    SwitchAccountState state, Action action) {
  final SwitchAccountState newState = state.clone();
  return newState;
}

// SwitchAccountState _onDevLogin(SwitchAccountState state, Action action) {
//   final SwitchAccountState newState = state.clone();
//   newState.canEntryHomePage = action.payload['canEntryHomePage'];
//   newState.localUserInfoList = action.payload['localUserInfoList'];
//   return newState;
// }
