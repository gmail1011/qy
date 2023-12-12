import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/video_model.dart';

enum MainPlayerListAction {
  refreshListOkay,
  refreshData,
  loadMoreData,

  configAdsStatus,
  showAdsView,
  onRefreshFollowStatus,
  beginAutoPlay,
  refreshFollowStatus,
}

///推荐界面action
class MainPlayerListActionCreator {
  ///本页面刷新
  static Action refreshFollowStatus() {
    return Action(
      MainPlayerListAction.refreshFollowStatus,
    );
  }

  /// 更新当前的播放索引
  static Action setAutoPlayIndex(int index) {
    return Action(MainPlayerListAction.beginAutoPlay, payload: index);
  }

  static Action onRefreshFollowStatus(Map<String, dynamic> map) {
    return Action(MainPlayerListAction.onRefreshFollowStatus, payload: map);
  }

  /// 覆盖刷新
  static Action onRefreshListOkay(List<VideoModel> videoList) {
    return Action(MainPlayerListAction.refreshListOkay, payload: videoList);
  }

  ///获取更多数据
  static Action loadMoreData() {
    return Action(MainPlayerListAction.loadMoreData);
  }

  static Action refreshData() {
    return Action(MainPlayerListAction.refreshData);
  }

  ///显示小广告 -- reducer
  static Action showAdsOkay(AdsInfoBean adsInfoBean) {
    return Action(MainPlayerListAction.showAdsView, payload: adsInfoBean);
  }

  // static Action showAdsOkayBroadcast(AdsInfoBean adsInfoBean) {
  //   return Action(RecommendListAction.showAdsOkayBroadcast,
  //       payload: adsInfoBean);
  // }

  ///显示小广告
  static Action configAdsStatus(bool showBig) {
    return Action(MainPlayerListAction.configAdsStatus, payload: showBig);
  }
}
