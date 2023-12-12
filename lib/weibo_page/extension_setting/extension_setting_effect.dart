import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ExtensionBean.dart';
import 'package:flutter_app/model/ads_model.dart';

import 'extension_setting_action.dart';
import 'extension_setting_state.dart';

Effect<ExtensionSettingState> buildEffect() {
  return combineEffects(<Object, Effect<ExtensionSettingState>>{
    ExtensionSettingAction.action: _onAction,
    Lifecycle.initState: _onInit,
  });
}

void _onAction(Action action, Context<ExtensionSettingState> ctx) {}

void _onInit(Action action, Context<ExtensionSettingState> ctx) async {
  ///获取广告
  List<AdsInfoBean> list = await getAdsByType(AdsType.ProMoteSetting);

  ctx.dispatch(ExtensionSettingActionCreator.onGetAds(list));

  var model = await netManager.client.getPromoteConfig();

  List<SelectBean> data = List<SelectBean>.from(model.map((x) => SelectBean.fromJson(x)));

  ctx.dispatch(ExtensionSettingActionCreator.onGetData(data));

}
