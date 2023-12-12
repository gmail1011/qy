import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'model/refresh_model.dart';

enum VideoUserCenterAction {
  onLoadUserInfo,
  onFollow,
  updateUserInfo,
  refreshFollowStatus,
  onBack,
  onUpdateUid,
  onRefreshFollowStatus,
  configSliderStatus,
  initView,
  onShowFollow,
  showFollow,
  onIsShowTopBtn,
  showTopBtn
}

class VideoUserCenterActionCreator {
  static Action onLoadUserInfo() {
    return const Action(VideoUserCenterAction.onLoadUserInfo);
  }

  static Action onIsShowTopBtn(bool isShow) {
    return Action(VideoUserCenterAction.onIsShowTopBtn, payload: isShow);
  }

  static Action setIsShowTopBtn(bool isShow) {
    return Action(VideoUserCenterAction.showTopBtn, payload: isShow);
  }

  static Action onFollow(bool follow) {
    return Action(VideoUserCenterAction.onFollow, payload: follow);
  }

  static Action onRefreshFollowStatus(Map<String, dynamic> map) {
    return Action(VideoUserCenterAction.onRefreshFollowStatus, payload: map);
  }

  static Action updateUserInfo(UserInfoModel userInfoModel) {
    return Action(VideoUserCenterAction.updateUserInfo, payload: userInfoModel);
  }

  static Action refreshFollowStatus(bool isFollow) {
    return Action(VideoUserCenterAction.refreshFollowStatus, payload: isFollow);
  }

  static Action onBack() {
    return Action(VideoUserCenterAction.onBack);
  }

  ///修改UID
  static Action onUpdateUid(RefreshModel refreshModel) {
    return Action(VideoUserCenterAction.onUpdateUid, payload: refreshModel);
  }

  static Action configSliderStatus(bool isShow) {
    return Action(VideoUserCenterAction.configSliderStatus, payload: isShow);
  }

  static Action initView([bool initUser = true]) {
    return Action(VideoUserCenterAction.initView, payload: initUser);
  }

  ///界面刷新
  static Action showFollowBtn(bool isShow) {
    return Action(VideoUserCenterAction.showFollow, payload: isShow);
  }

  ///接收外部事件
  static Action onShowFollowBtnUI(bool isShow) {
    return Action(VideoUserCenterAction.onShowFollow, payload: isShow);
  }
}
