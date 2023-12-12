import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/search/hot_search_list/hot_model.dart';

enum DiscoveryAction {
  action,
  search,
  setAreaList,
  setFindList,
  onAreaClick,
  onFindClick,
  loadData,
  loadMoreData,
  loadMoreFindData
}

class DiscoveryActionCreator {
  static Action loadData() {
    return Action(DiscoveryAction.loadData);
  }

  static Action loadMoreData() {
    return Action(DiscoveryAction.loadMoreData);
  }

  static Action onAreaClick(AreaModel model) {
    return Action(DiscoveryAction.onAreaClick, payload: model);
  }

  static Action onFindClick(FindModel model) {
    return Action(DiscoveryAction.onFindClick, payload: model);
  }

  static Action onSearch() {
    return const Action(DiscoveryAction.search);
  }

  static Action setFindList(List<FindModel> list) {
    return Action(DiscoveryAction.setFindList, payload: list);
  }

  static Action loadMoreFindData(List<FindModel> list) {
    return Action(DiscoveryAction.loadMoreFindData, payload: list);
  }

  static Action setAreaList(List<AreaModel> list) {
    return Action(DiscoveryAction.setAreaList, payload: list);
  }
}
