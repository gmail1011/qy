import 'package:fish_redux/fish_redux.dart';

import 'topic_detail_action.dart';
import 'topic_detail_state.dart';

Reducer<TopicDetailState> buildReducer() {
  return asReducer(
    <Object, Reducer<TopicDetailState>>{
      TopicDetailAction.action: _onAction,
      TopicDetailAction.getData: _onGetData,
      TopicDetailAction.setCollect: _onSetCollect,
      TopicDetailAction.getVideoData: _onGetVideoData,
      TopicDetailAction.getMovieData: _onGetMovieData,
      TopicDetailAction.onLoadMore: _onLoadMore,
      TopicDetailAction.onVideoLoadmore: _onVideoLoadMore,
      TopicDetailAction.onMovieLoadmore: _onMovieLoadMore,
      TopicDetailAction.getPlayCount: _onGetPlayCount,
    },
  );
}

TopicDetailState _onAction(TopicDetailState state, Action action) {
  final TopicDetailState newState = state.clone();
  return newState;
}

TopicDetailState _onLoadMore(TopicDetailState state, Action action) {
  final TopicDetailState newState = state.clone();
  newState.pageNumber = action.payload;
  return newState;
}

TopicDetailState _onGetPlayCount(TopicDetailState state, Action action) {
  final TopicDetailState newState = state.clone();
  newState.playCount = action.payload;
  return newState;
}

TopicDetailState _onVideoLoadMore(TopicDetailState state, Action action) {
  final TopicDetailState newState = state.clone();
  newState.pageVideoNumber = action.payload;
  return newState;
}

TopicDetailState _onMovieLoadMore(TopicDetailState state, Action action) {
  final TopicDetailState newState = state.clone();
  newState.pageMovieNumber = action.payload;
  return newState;
}


TopicDetailState _onGetData(TopicDetailState state, Action action) {
  final TopicDetailState newState = state.clone();
  newState.tagBean = action.payload;
  return newState;
}

TopicDetailState _onGetVideoData(TopicDetailState state, Action action) {
  final TopicDetailState newState = state.clone();
  newState.tagVideoBean = action.payload;
  return newState;
}

TopicDetailState _onGetMovieData(TopicDetailState state, Action action) {
  final TopicDetailState newState = state.clone();
  newState.tagMovieBean = action.payload;
  return newState;
}

TopicDetailState _onSetCollect(TopicDetailState state, Action action) {
  final TopicDetailState newState = state.clone();
  newState.isCollected = action.payload;
  return newState;
}

