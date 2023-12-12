import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SearchVideoState> buildReducer() {
  return asReducer(
    <Object, Reducer<SearchVideoState>>{
      SearchVideoAction.setLoadData: _setVideoData,
      SearchVideoAction.setLoadMoreData: _setLoadMoreData,
      SearchVideoAction.setKeywords: _setKeywords,
    },
  );
}

SearchVideoState _setKeywords(SearchVideoState state, Action action) {
  final SearchVideoState newState = state.clone();
  newState.keywords = action.payload;
  return newState;
}

SearchVideoState _setVideoData(SearchVideoState state, Action action) {
  final SearchVideoState newState = state.clone();
  newState.searchVideos = action.payload;
  newState.pageNumber = 1;
  return newState;
}

SearchVideoState _setLoadMoreData(SearchVideoState state, Action action) {
  final SearchVideoState newState = state.clone();
  newState.searchVideos.addAll(action.payload);
  newState.pageNumber++;
  return newState;
}
