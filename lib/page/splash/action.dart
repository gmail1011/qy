import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';

enum SplashAction {
  jumpHomePage,
  changeText,
  openUpdate,
  showAds,
  onCountDownTime,
  onAdvTag,
  onFuckIt,
  onAreaList,
  onFindList,
  onCommunityList,
}

class SplashActionCreator {
  ///进入主界面
  static Action onJumpHomePage() {
    return const Action(SplashAction.jumpHomePage);
  }

  ///初始化AreaList(发现页面)
  static Action onAreaList(var list) {
    return Action(SplashAction.onAreaList, payload: list);
  }

  ///初始化FindList
  static Action onFindList(var list) {
    return Action(SplashAction.onFindList, payload: list);
  }

  ///改变顶部文字提示
  static Action onChangeText() {
    return Action(SplashAction.changeText);
  }

  /// 获取撩吧推荐数据
  static Action onFuckIt(var list) {
    return Action(SplashAction.onFuckIt, payload: list);
  }

  ///改变顶部文字提示
  static Action openUpdate() {
    return Action(SplashAction.openUpdate);
  }

  ///显示广告
  static Action showAds(AdsInfoBean adsBeans) {
    return Action(SplashAction.showAds, payload: adsBeans);
  }

  /// 倒计时
  static Action onCountDownTime(int time) {
    return Action(SplashAction.onCountDownTime, payload: time);
  }

  ///点击广告进入浏览器
  static Action onAdvTag(AdsInfoBean adsInfoBean) {
    return Action(SplashAction.onAdvTag, payload: adsInfoBean);
  }

  static Action onCommunityList(var community) {
    return Action(SplashAction.onCommunityList, payload: community);
  }
}
