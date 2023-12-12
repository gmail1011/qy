import 'package:fish_redux/fish_redux.dart';

import 'extension_setting_action.dart';
import 'extension_setting_state.dart';

Reducer<ExtensionSettingState> buildReducer() {
  return asReducer(
    <Object, Reducer<ExtensionSettingState>>{
      ExtensionSettingAction.action: _onAction,
      ExtensionSettingAction.getAds: _onGetAds,
      ExtensionSettingAction.getData: _onGetData,
      ExtensionSettingAction.refreshUi: _onSelectValue,
    },
  );
}

ExtensionSettingState _onAction(ExtensionSettingState state, Action action) {
  final ExtensionSettingState newState = state.clone();
  return newState;
}


ExtensionSettingState _onGetAds(ExtensionSettingState state, Action action) {
  final ExtensionSettingState newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}


ExtensionSettingState _onGetData(ExtensionSettingState state, Action action) {
  final ExtensionSettingState newState = state.clone();
  newState.selectBean = action.payload;
  return newState;
}


ExtensionSettingState _onSelectValue(ExtensionSettingState state, Action action) {
  final ExtensionSettingState newState = state.clone();
  newState.selectedValue = action.payload;
  return newState;
}
