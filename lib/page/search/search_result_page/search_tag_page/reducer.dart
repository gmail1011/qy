import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SearchTagState> buildReducer() {
  return asReducer(
    <Object, Reducer<SearchTagState>>{
      SearchTagAction.setLoadData: _setVideoData,
      SearchTagAction.setLoadMoreData: _setLoadMoreData,
      SearchTagAction.setKeywords: _setKeywords,
      SearchTagAction.refreshCollectTag: _refreshCollectTag,
    },
  );
}

SearchTagState _refreshCollectTag(SearchTagState state, Action action) {
  final SearchTagState newState = state.clone();
  var index = action.payload as int;
  var tag = newState.searchTags[index];
  tag.hasCollected = !tag.hasCollected;
  return newState;
}

SearchTagState _setKeywords(SearchTagState state, Action action) {
  final SearchTagState newState = state.clone();
  newState.keywords = action.payload;
  return newState;
}

SearchTagState _setVideoData(SearchTagState state, Action action) {
  final SearchTagState newState = state.clone();
  newState.searchTags = action.payload;
  newState.pageNumber = 1;
  return newState;
}

SearchTagState _setLoadMoreData(SearchTagState state, Action action) {
  final SearchTagState newState = state.clone();
  newState.searchTags.addAll(action.payload);
  newState.pageNumber++;
  return newState;
}
