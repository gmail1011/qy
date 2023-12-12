import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SettingState> buildReducer() {
  return asReducer(
    <Object, Reducer<SettingState>>{
      Lifecycle.initState: _initState,
      SettingAction.clearCacheSuccess: _onClearCacheSuccess,
      SettingAction.getTuiGuangCode: _onGetTuiGuangCode,
    },
  );
}

SettingState _initState(SettingState state, Action action) {
  SettingState newState = state.clone();
  return newState;
}

SettingState _onClearCacheSuccess(SettingState state, Action action) {
  SettingState newState = state.clone();
  return newState;
}


SettingState _onGetTuiGuangCode(SettingState state, Action action) {
  final SettingState newState = state.clone()..tuiGuangCode = action.payload;
  return newState;
}