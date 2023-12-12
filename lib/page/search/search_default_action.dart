import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/search_default_entity.dart';

//TODO replace with your own action
enum SearchDefaultAction { action , initData}

class SearchDefaultActionCreator {
  static Action onAction() {
    return const Action(SearchDefaultAction.action);
  }

  static Action onInitData(SearchDefaultData searchDefaultData) {
    return Action(SearchDefaultAction.initData,payload: searchDefaultData);
  }
}
