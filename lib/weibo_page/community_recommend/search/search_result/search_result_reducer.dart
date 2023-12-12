import 'package:fish_redux/fish_redux.dart';

import 'search_result_action.dart';
import 'search_result_state.dart';

Reducer<SearchResultState> buildReducer() {
  return asReducer(
    <Object, Reducer<SearchResultState>>{
      SearchResultAction.action: _onAction,
      SearchResultAction.getMovieData: getSearchMovie,
      SearchResultAction.onMovieLoadMore: onMovieLoadMore,
      SearchResultAction.getVideoData: getSearchVideo,
      SearchResultAction.onVideoLoadMore: onVideoLoadMore,
      SearchResultAction.getWordData: getSearchWord,
      SearchResultAction.onWordLoadMore: onWordLoadMore,
      SearchResultAction.getUserData: getSearchUser,
      SearchResultAction.onUserLoadMore: onUserLoadMore,
      SearchResultAction.getTopicData: getSearchTopic,
      SearchResultAction.onTopicLoadMore: onTopicLoadMore,
      SearchResultAction.setKeyWord: setKeyWord,
    },
  );
}

SearchResultState _onAction(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  return newState;
}

SearchResultState getSearchMovie(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  newState.searchMovieData = action.payload;
  return newState;
}

SearchResultState onMovieLoadMore(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  newState.moviePageNum = action.payload;
  return newState;
}



SearchResultState getSearchVideo(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  newState.searchVideoData = action.payload;
  return newState;
}

SearchResultState onVideoLoadMore(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  newState.videoPageNum = action.payload;
  return newState;
}



SearchResultState getSearchWord(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  newState.searchWordData = action.payload;
  return newState;
}

SearchResultState onWordLoadMore(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  newState.wordPageNum = action.payload;
  return newState;
}


SearchResultState getSearchUser(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  newState.searchBeanData = action.payload;
  return newState;
}

SearchResultState onUserLoadMore(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  newState.userPageNum = action.payload;
  return newState;
}


SearchResultState getSearchTopic(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  newState.searchBeanDataTopic = action.payload;
  return newState;
}

SearchResultState onTopicLoadMore(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  newState.topicPageNum = action.payload;
  return newState;
}

SearchResultState setKeyWord(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  newState.keyword = action.payload;
  return newState;
}
