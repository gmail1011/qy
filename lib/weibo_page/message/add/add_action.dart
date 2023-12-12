import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_bean_entity.dart';

import 'add_user_entity.dart';

enum AddAction {
  action,
  getData,
  onLoadMore,
  onUserLoadMore,
  getUserData,
  setSearchUser,
}

class AddActionCreator {
  static Action onAction() {
    return Action(AddAction.action);
  }

  static Action getData(AddUserData fansObj) {
    return Action(AddAction.getData, payload: fansObj);
  }

  static Action onLoadMore(int fansObj) {
    return Action(AddAction.onLoadMore, payload: fansObj);
  }

  static Action onUserLoadMore(int fansObj) {
    return Action(AddAction.onUserLoadMore, payload: fansObj);
  }

  static Action getUserData(SearchBeanData fansObj) {
    return Action(AddAction.getUserData, payload: fansObj);
  }

  static Action setSearchUser(bool fansObj) {
    return Action(AddAction.setSearchUser, payload: fansObj);
  }
}
