import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SpecialTopicState> buildReducer() {
  return asReducer(
    <Object, Reducer<SpecialTopicState>>{
      SpecialTopicAction.setLoadData: _loadData,
      SpecialTopicAction.setLoadMoreData: _loadMoreData,
      SpecialTopicAction.setAds: _setAds
    },
  );
}

SpecialTopicState _loadData(SpecialTopicState state, Action action) {
  final SpecialTopicState newState = state.clone();
  newState.pageNumber = 1;
  newState.list = action.payload;
  return newState;
}

SpecialTopicState _loadMoreData(SpecialTopicState state, Action action) {
  final SpecialTopicState newState = state.clone();
  newState.pageNumber++;
  newState.list.addAll(action.payload);
  return newState;
}

SpecialTopicState _setAds(SpecialTopicState state, Action action) {
  final SpecialTopicState newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}
