import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/audiobook_model.dart';

import 'action.dart';
import 'state.dart';

Reducer<AudioNovelState> buildReducer() {
  return asReducer(
    <Object, Reducer<AudioNovelState>>{
      AudioNovelAction.playAudioEpisode: _playAudioEpisode,
      AudioNovelAction.getAudioBookOkay: _getAudioBookOkay,
      AudioNovelAction.refresh: _onRefresh,
      AudioNovelAction.setRecommendList: _setRecommendList,
      AudioNovelAction.refreshCollectAnchor: _refreshCollectAnchor,
      AudioNovelAction.refreshCollectAudioBook: _refreshCollectAudioBook,
      AudioNovelAction.getRecordOkay: _getRecordOkay,
    },
  );
}

AudioNovelState _getRecordOkay(AudioNovelState state, Action action) {
  return state.clone()..record = action.payload;
}

AudioNovelState _refreshCollectAnchor(AudioNovelState state, Action action) {
  final AudioNovelState newState = state.clone();
  newState.audioBook.anchorInfo.isCollect =
      !newState.audioBook.anchorInfo.isCollect;
  return newState;
}

AudioNovelState _refreshCollectAudioBook(AudioNovelState state, Action action) {
  final AudioNovelState newState = state.clone();
  newState.audioBook.isCollect = !newState.audioBook.isCollect;
  return newState;
}

AudioNovelState _setRecommendList(AudioNovelState state, Action action) {
  final AudioNovelState newState = state.clone();
  newState.recommendList = action.payload;
  return newState;
}

AudioNovelState _onRefresh(AudioNovelState state, Action action) {
  final AudioNovelState newState = state.clone();
  return newState;
}

AudioNovelState _playAudioEpisode(AudioNovelState state, Action action) {
  var episode = action.payload as EpisodeModel;
  if (null != episode) {
    return state.clone()
      ..episodeNumber = episode.episodeNumber
      ..url = episode.contentUrl;
  } else {
    return state;
  }
}

AudioNovelState _getAudioBookOkay(AudioNovelState state, Action action) {
  var audioBook = action.payload as AudioBook;
  return state.clone()
    ..audioBook = audioBook
    ..id = audioBook.id;
}
