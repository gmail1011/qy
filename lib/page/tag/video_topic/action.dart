import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/special_model.dart';

enum VideoTopicAction {
  loadData,
  setLoadData,
  loadMoreData,
  setLoadMoreData,
  tagClick,

  setAds,
}

class VideoTopicActionCreator {
  static Action setAds(List<AdsInfoBean> adsList) {
    return Action(VideoTopicAction.setAds, payload: adsList);
  }

  static Action loadData() {
    return const Action(VideoTopicAction.loadData);
  }

  static Action setLoadData(List<ListBeanSp> list) {
    return Action(VideoTopicAction.setLoadData, payload: list);
  }

  static Action loadMoreData() {
    return const Action(VideoTopicAction.loadMoreData);
  }

  static Action setLoadMoreData(List<ListBeanSp> list) {
    return Action(VideoTopicAction.setLoadMoreData, payload: list);
  }

  static Action onTagClick(ListBeanSp item) {
    return Action(VideoTopicAction.tagClick, payload: item);
  }
}
