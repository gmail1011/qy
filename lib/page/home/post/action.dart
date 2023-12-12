import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';

enum PostAction {
  refreshUI,
  getAdsSuccess,
  onFeatured,
  onRank,
  onActivity,
  onTag,
  onSearch,
  onGetTaskId,
  onSelectUploadType,
  onRefreshAllData,
  onIsShowTopBtn,
  setIsShowTopBtn,
  getAnnounce,
}

class PostActionCreator {
  static Action refreshUI() {
    return const Action(PostAction.refreshUI);
  }

  static Action onGetTaskId(String taskId) {
    return Action(PostAction.onGetTaskId, payload: taskId);
  }

  ///弹出选择提示框
  static Action onSelectUploadType() {
    return const Action(PostAction.onSelectUploadType);
  }

  ///回到顶部按钮显示状态
  static Action onIsShowTopBtn(bool isShow) {
    return Action(PostAction.onIsShowTopBtn, payload: isShow);
  }

  ///回到顶部按钮显示状态
  static Action setIsShowTopBtn(bool isShow) {
    return Action(PostAction.setIsShowTopBtn, payload: isShow);
  }

  ///刷新聊吧所有数据
  static Action onRefreshAllData() {
    return Action(PostAction.onRefreshAllData);
  }

  ///广告获取成功
  static Action getAdsSuccess(List<AdsInfoBean> list) {
    return Action(PostAction.getAdsSuccess, payload: list);
  }

  ///点击精选
  static Action onFeatured() {
    return Action(PostAction.onFeatured);
  }

  ///点击榜单
  static Action onRank() {
    return Action(PostAction.onRank);
  }

  ///点击活动
  static Action onActivity() {
    return Action(
      PostAction.onActivity,
    );
  }

  ///点击标签
  static Action onTag() {
    return Action(
      PostAction.onTag,
    );
  }

  ///点击搜索
  static Action onSearch() {
    return Action(PostAction.onSearch);
  }

  static Action onAnnounce(String announce) {
    return Action(PostAction.getAnnounce,payload: announce);
  }
}
