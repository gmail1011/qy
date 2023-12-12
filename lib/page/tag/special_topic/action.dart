import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/special_model.dart';

enum SpecialTopicAction {
  loadData,
  setLoadData,
  loadMoreData,
  setLoadMoreData,
  tagClick,

  setAds,
}

class SpecialTopicActionCreator {
  static Action setAds(List<AdsInfoBean> adsList) {
    return Action(SpecialTopicAction.setAds, payload: adsList);
  }

  static Action loadData() {
    return const Action(SpecialTopicAction.loadData);
  }

  static Action setLoadData(List<ListBeanSp> list) {
    return Action(SpecialTopicAction.setLoadData, payload: list);
  }

  static Action loadMoreData() {
    return const Action(SpecialTopicAction.loadMoreData);
  }

  static Action setLoadMoreData(List<ListBeanSp> list) {
    return Action(SpecialTopicAction.setLoadMoreData, payload: list);
  }

  static Action onTagClick(ListBeanSp item) {
    return Action(SpecialTopicAction.tagClick, payload: item);
  }
}
