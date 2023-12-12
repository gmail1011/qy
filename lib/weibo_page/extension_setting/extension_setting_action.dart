import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ExtensionBean.dart';
import 'package:flutter_app/model/ads_model.dart';

//TODO replace with your own action
enum ExtensionSettingAction { action , getAds , getData , refreshUi }

class ExtensionSettingActionCreator {
  static Action onAction() {
    return const Action(ExtensionSettingAction.action);
  }


  static Action onGetAds(List<AdsInfoBean> adsList ) {
    return  Action(ExtensionSettingAction.getAds,payload: adsList);
  }

  static Action onGetData( List<SelectBean> selectBean) {
    return  Action(ExtensionSettingAction.getData,payload: selectBean);
  }

  static Action onSelectValue(int value) {
    return  Action(ExtensionSettingAction.refreshUi,payload: value);
  }
}
