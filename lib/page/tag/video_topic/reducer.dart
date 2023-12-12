import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<VideoTopicState> buildReducer() {
  return asReducer(
    <Object, Reducer<VideoTopicState>>{
      VideoTopicAction.setLoadData: _loadData,
      VideoTopicAction.setLoadMoreData: _loadMoreData,
      VideoTopicAction.setAds: _setAds
    },
  );
}

VideoTopicState _loadData(VideoTopicState state, Action action) {
  final VideoTopicState newState = state.clone();
  newState.pageNumber = 1;
  newState.list = action.payload;
  return newState;
}

VideoTopicState _loadMoreData(VideoTopicState state, Action action) {
  final VideoTopicState newState = state.clone();
  newState.pageNumber++;
  newState.list.addAll(action.payload);
  return newState;
}

VideoTopicState _setAds(VideoTopicState state, Action action) {
  final VideoTopicState newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}
