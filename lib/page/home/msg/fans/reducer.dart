import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<FansState> buildReducer() {
  return asReducer(
    <Object, Reducer<FansState>>{
      FansAction.onLoadFansAction: _onLoadFans,
      FansAction.refreshUI:_refreshUI,
    },
  );
}

FansState _onLoadFans(FansState state, Action action) {
  final FansState newState = state.clone();
  if (newState.fansList == null) {
    newState.fansList = [];
  }
  newState.fansList.addAll(action.payload['data']);
  newState.fansList.forEach((fans) {
    fans.isFans = true;
  });
  newState.hasNext = action.payload['hasNext'];
  return newState;
}

FansState _refreshUI(FansState state, Action action) {
  final FansState newState = state.clone();
  return newState;
}
