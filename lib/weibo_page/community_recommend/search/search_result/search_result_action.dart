import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_bean_entity.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_topic_entity.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_video_entity.dart';

//TODO replace with your own action
enum SearchResultAction {
  action,
  getMovieData,
  onMovieLoadMore,
  getVideoData,
  onVideoLoadMore,
  getWordData,
  onWordLoadMore,
  getUserData,
  onUserLoadMore,
  getTopicData,
  onTopicLoadMore,
  setKeyWord,
  search,
}

class SearchResultActionCreator {
  static Action onAction() {
    return Action(SearchResultAction.action);
  }

  static Action getMovieData(SearchVideoData searchMovieData) {
    return Action(SearchResultAction.getMovieData, payload: searchMovieData);
  }

  static Action onMovieLoadMore(int pageNum) {
    return Action(SearchResultAction.onMovieLoadMore, payload: pageNum);
  }

  static Action getVideoData(SearchVideoData searchMovieData) {
    return Action(SearchResultAction.getVideoData, payload: searchMovieData);
  }

  static Action onVideoLoadMore(int pageNum) {
    return Action(SearchResultAction.onVideoLoadMore, payload: pageNum);
  }

  static Action getWordData(SearchVideoData searchMovieData) {
    return Action(SearchResultAction.getWordData, payload: searchMovieData);
  }

  static Action onWordLoadMore(int pageNum) {
    return Action(SearchResultAction.onWordLoadMore, payload: pageNum);
  }

  static Action getUserData(SearchBeanData searchMovieData) {
    return Action(SearchResultAction.getUserData, payload: searchMovieData);
  }

  static Action onUserLoadMore(int pageNum) {
    return Action(SearchResultAction.onUserLoadMore, payload: pageNum);
  }

  static Action getTopicData(SearchTopicData searchMovieData) {
    return Action(SearchResultAction.getTopicData, payload: searchMovieData);
  }

  static Action onTopicLoadMore(int pageNum) {
    return Action(SearchResultAction.onTopicLoadMore, payload: pageNum);
  }

  static Action setKeyWord(String keyWord) {
    return Action(SearchResultAction.setKeyWord, payload: keyWord);
  }
}
