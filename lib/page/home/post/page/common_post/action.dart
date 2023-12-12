import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/selected_tags_entity.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';

enum CommonPostAction {
  onInit,
  onLoadMore,
  initListSuccess,
  loadMoreSuccess,
  refreshFollowStatus,
  onListenerRefreshData,
  onRefreshFollowStatus,
  getAdsSuccess,
  tagClick,
  getDailyData,
  getDailyDataLoadMore,
  //setLoadMoreData,
}

class CommonPostActionCreator {
  ///刷新数据
  static Action onInit() {
    return Action(CommonPostAction.onInit);
  }

  ///监听点击底部聊吧导按钮发出的刷新通知
  static Action onListenerRefreshData(int tabIndex) {
    return Action(CommonPostAction.onListenerRefreshData, payload: tabIndex);
  }

  static Action onRefreshFollowStatus(Map<String, dynamic> map) {
    return Action(CommonPostAction.onRefreshFollowStatus, payload: map);
  }

  static Action refreshFollowStatus(Map<String, dynamic> map) {
    return Action(CommonPostAction.refreshFollowStatus, payload: map);
  }

  ///加载更多
  static Action onLoadMore(int pageNum) {
    return Action(CommonPostAction.onLoadMore,payload: pageNum);
  }

  static Action initListSuccess(List<TagsDetailDataSections> items) {
    return Action(CommonPostAction.initListSuccess, payload: items);
  }

  ///加载更多
  //static Action loadMoreSuccess(List<PostItemState> items) {
  static Action setLoadMoreData(List<TagsDetailDataSections> list) {
    //return Action(CommonPostAction.loadMoreSuccess, payload: items);

    return Action(CommonPostAction.loadMoreSuccess, payload: list);
  }

  ///广告获取成功
  static Action getAdsSuccess(List<AdsInfoBean> list) {
    return Action(CommonPostAction.getAdsSuccess, payload: list);
  }

  static Action onTagClick(ListBeanSp item) {
    return Action(CommonPostAction.tagClick, payload: item);
  }

  static Action onGetDailyData(SelectedTagsData selectedTagsData) {
    return Action(CommonPostAction.getDailyData, payload: selectedTagsData);
  }
  static Action onGetDailyDataLoadMore(int pageNum) {
    return Action(CommonPostAction.getDailyDataLoadMore, payload: pageNum);
  }

  /*static Action setLoadMoreData(List<ListBeanSp> list) {
    return Action(CommonPostAction.setLoadMoreData, payload: list);
  }*/
}
