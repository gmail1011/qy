import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';

//TODO replace with your own action
enum YuePaoAction {
  selectCity,
  onChangeCity,
  getAdsSuccess,
}

class YuePaoActionCreator {
  static Action onChangeCity(String city) {
    return Action(YuePaoAction.onChangeCity, payload: city);
  }
  static Action onSelectCity() {
    return Action(YuePaoAction.selectCity);
  }
  ///广告获取成功
  static Action getAdsSuccess(List<AdsInfoBean> list) {
    return Action(YuePaoAction.getAdsSuccess, payload: list);
  }
}
