import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<OfflineCacheState> buildReducer() {
  return asReducer(
    <Object, Reducer<OfflineCacheState>>{
      OfflineCacheAction.action: _onAction,
    },
  );
}

OfflineCacheState _onAction(OfflineCacheState state, Action action) {
  final OfflineCacheState newState = state.clone();
  return newState;
}
