import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/search/search_user_model.dart';

enum SearchUserAction {
  loadData,
  setLoadData,
  loadMoedData,
  setLoadMoreData,
  broadcastSearchAction,
  setKeywords,
  followUser,
  refreshFollowUser
}

class SearchUserActionCreator {
  static Action refreshFollowUser(int index) {
    return Action(SearchUserAction.refreshFollowUser, payload: index);
  }

  static Action followUser(int index) {
    return Action(SearchUserAction.followUser, payload: index);
  }

  static Action setKeywords(String keywords) {
    return Action(SearchUserAction.setKeywords, payload: keywords);
  }

  static Action broadcastSearchAction(String keywords) {
    return Action(SearchUserAction.broadcastSearchAction, payload: keywords);
  }

  static Action loadData() {
    return const Action(SearchUserAction.loadData);
  }

  static Action setLoadData(List<SearchUserModel> list) {
    return Action(SearchUserAction.setLoadData, payload: list);
  }

  static Action loadMoedData() {
    return const Action(SearchUserAction.loadMoedData);
  }

  static Action setLoadMoreData(List<SearchUserModel> list) {
    return Action(SearchUserAction.setLoadMoreData, payload: list);
  }
}
