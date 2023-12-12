import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/page/setting/setting_main/view.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_app/utils/version_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'action.dart';
import 'state.dart';

Effect<SettingState> buildEffect() {
  return combineEffects(<Object, Effect<SettingState>>{
    SettingAction.backAction: _backAction,
    SettingAction.bindPromotionCode: _onBindPromotionCode,
    SettingAction.exChangeCode: _onExChangeCode,
    SettingAction.tuiGuangCode: _onTuiGuangCode,
    SettingAction.queryTuiGuangCode: _queryTuiGuangCode,
    Lifecycle.initState: _initState,
  });
}

Future<void> _initState(Action action, Context<SettingState> ctx) async {
  String _size = await loadCache();

  ctx.state.cacheSize = _size;
  ctx.dispatch(SettingActionCreator.clearCacheSuccess());
  ctx.dispatch(SettingActionCreator.queryTuiGunangCode());
  Future.delayed(Duration(milliseconds: 200),(){
    //eaglePage(ctx.state.selfId(),
          //sourceId: ctx.state.eagleId(ctx.context));
  });
  
}

void _onGetVersion(Action action, Context<SettingState> ctx) async {
  var versionMap = await checkUpdate();
  if (versionMap != null) {
    if (!(versionMap['isNeedUpdate'] ?? false)) {
      showNotUpgradeDialog(ctx.context);
    } else {
      showUpgradeDialog(ctx.context, versionMap['newVersion'] ?? '',
          versionMap['versionBean']);
    }
  }
}

void _backAction(Action action, Context<SettingState> ctx) {
  safePopPage();
}

void _onExChangeCode(Action action, Context<SettingState> ctx) async {
  try {
    String code = action.payload ?? "";
    await netManager.client.postExChangeCode(code);
    showToast(msg: Lang.REDEMPTION_SUCCESS);
  } catch (e) {
    l.d('postExChangeCode', e.toString());
    showToast(msg: e.toString());
  }
}

void _onTuiGuangCode(Action action, Context<SettingState> ctx) async {
  try {
    String code = action.payload ?? "";


    DateTime createdAtTime = DateTime.parse(GlobalStore.getMe().createdAt);
    DateTime createdAtTimeAdd24 = createdAtTime.add(Duration(days: 1));
    DateTime nowTime = DateTime.now();

    if(createdAtTimeAdd24.isBefore(nowTime)){
      showToast(msg: "注册时间超过24小时，不能绑定");
      return;
    }

    dynamic dataResult = await netManager.client.postTuiGuangCode(code);
    if(dataResult["data"] == "success"){
      showToast(msg: Lang.BIND_PROMOTION_SUCCESS);
    }else{
      //showToast(msg: dataResult["tip"] ?? "绑定失败");
    }

  } catch (e) {
    l.d('postExChangeCode', e.toString());
    showToast(msg: e.toString());
  }
}

void _onBindPromotionCode(Action action, Context<SettingState> ctx) {
  bindPromotionCode(ctx, action.payload);
}

/// 绑定推广码
bindPromotionCode(Context<SettingState> ctx, String promotionCode) async {
  try {

    await netManager.client.getProxyBind(promotionCode);
    showToast(msg: Lang.BIND_SUCCESS);
    GlobalStore.updateUserInfo(null);
  } catch (e) {
    l.d('getProxyBind', e.toString());
    showToast(msg: e.toString() ?? '');
  }
}

///查询是否绑定推广码
void _queryTuiGuangCode(Action action, Context<SettingState> ctx) async {
  try {
    String code = action.payload ?? "";
    dynamic data = await netManager.client.QUERY_TUI_GUANG();
    dynamic codeTuiGuang = data["inviter"];
    ctx.dispatch(SettingActionCreator.getTuiGuangCode(codeTuiGuang?.toString()));
  } catch (e) {
    l.d('postExChangeCode', e.toString());
    showToast(msg: e.toString());
  }
}
