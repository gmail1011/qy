import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';

//TODO replace with your own action
enum YuePaoTabAction { action , getAds , getAnnounce}

class YuePaoTabActionCreator {
  static Action onAction() {
    return const Action(YuePaoTabAction.action);
  }

  static Action onGetAds(List<AdsInfoBean> list) {
    return  Action(YuePaoTabAction.getAds,payload: list);
  }

  static Action onGetAnnounce(String announce) {
    return  Action(YuePaoTabAction.getAnnounce,payload: announce);
  }
}
