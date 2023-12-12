import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';

enum SearchVideoAction {
  loadData,
  setLoadData,
  loadMoedData,
  setLoadMoreData,
  broadcastSearchAction,
  setKeywords
}

class SearchVideoActionCreator {
  static Action setKeywords(String keywords) {
    return Action(SearchVideoAction.setKeywords, payload: keywords);
  }

  static Action broadcastSearchAction(String keywords) {
    return Action(SearchVideoAction.broadcastSearchAction, payload: keywords);
  }

  static Action loadData() {
    return const Action(SearchVideoAction.loadData);
  }

  static Action setLoadData(List<VideoModel> list) {
    return Action(SearchVideoAction.setLoadData, payload: list);
  }

  static Action loadMoedData() {
    return const Action(SearchVideoAction.loadMoedData);
  }

  static Action setLoadMoreData(List<VideoModel> list) {
    return Action(SearchVideoAction.setLoadMoreData, payload: list);
  }
}
