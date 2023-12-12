import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<DiscoveryState> buildReducer() {
  return asReducer(
    <Object, Reducer<DiscoveryState>>{
      DiscoveryAction.setAreaList: _setAreaList,
      DiscoveryAction.setFindList: _setFindList,
      DiscoveryAction.loadMoreFindData: _loadMoreFindData,
    },
  );
}

DiscoveryState _setFindList(DiscoveryState state, Action action) {
  final DiscoveryState newState = state.clone();
  newState.findList = action.payload;
  return newState;
}

DiscoveryState _setAreaList(DiscoveryState state, Action action) {
  final DiscoveryState newState = state.clone();
  newState.areaList = action.payload;
  newState.pageNumber = 1;
  return newState;
}

DiscoveryState _loadMoreFindData(DiscoveryState state, Action action) {
  final DiscoveryState newState = state.clone();
  newState.findList.addAll(action.payload);
  newState.pageNumber++;
  return newState;
}
