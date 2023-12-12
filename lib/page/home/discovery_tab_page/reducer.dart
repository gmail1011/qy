import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<DiscoveryTabState> buildReducer() {
  return asReducer(
    <Object, Reducer<DiscoveryTabState>>{
      DiscoveryTabAction.onRefreshUI: _onRefreshUI,
      DiscoveryTabAction.getIndex: _onGetIndex,
    },
  );
}

DiscoveryTabState _onRefreshUI(DiscoveryTabState state, Action action) {
  final DiscoveryTabState newState = state.clone();
  return newState;
}

DiscoveryTabState _onGetIndex(DiscoveryTabState state, Action action) {
  final DiscoveryTabState newState = state.clone();
  newState.index = action.payload;
  return newState;
}
