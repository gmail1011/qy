import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/search/search_talk_model.dart';

enum SearchTagAction {
  loadData,
  setLoadData,
  loadMoedData,
  setLoadMoreData,
  broadcastSearchAction,
  setKeywords,
  collectTag,
  refreshCollectTag
}

class SearchTagActionCreator {
  static Action collectTag(int index) {
    return Action(SearchTagAction.collectTag, payload: index);
  }

  static Action refreshFollowUser(int index) {
    return Action(SearchTagAction.refreshCollectTag, payload: index);
  }

  static Action setKeywords(String keywords) {
    return Action(SearchTagAction.setKeywords, payload: keywords);
  }

  static Action broadcastSearchAction(String keywords) {
    return Action(SearchTagAction.broadcastSearchAction, payload: keywords);
  }

  static Action loadData() {
    return const Action(SearchTagAction.loadData);
  }

  static Action setLoadData(List<SearchTalkModel> list) {
    return Action(SearchTagAction.setLoadData, payload: list);
  }

  static Action loadMoedData() {
    return const Action(SearchTagAction.loadMoedData);
  }

  static Action setLoadMoreData(List<SearchTalkModel> list) {
    return Action(SearchTagAction.setLoadMoreData, payload: list);
  }
}
