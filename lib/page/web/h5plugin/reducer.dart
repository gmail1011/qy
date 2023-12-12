import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<H5PluginState> buildReducer() {
  return asReducer(
    <Object, Reducer<H5PluginState>>{
      H5PluginAction.loadH5PluginAction: _onLoadH5Plugin,
      H5PluginAction.updateTitle:_updateTitle,
    },
  );
}

H5PluginState _onLoadH5Plugin(H5PluginState state, Action action) {
  final H5PluginState newState = state.clone();
  return newState;
}

H5PluginState _updateTitle(H5PluginState state, Action action) {
  final H5PluginState newState = state.clone();
  newState.title = action.payload ?? "";
  return newState;
}
