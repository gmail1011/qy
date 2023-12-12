import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_store/local_user_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/page/setting/switch_account/action.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter/widgets.dart' hide Action;
import '../../../common/manager/cs_manager.dart';
import 'state.dart';

Effect<SwitchAccountState> buildEffect() {
  return combineEffects(<Object, Effect<SwitchAccountState>>{
    SwitchAccountAction.devLoginAction: _deviceLogin,
    SwitchAccountAction.onService: _onService,
    SwitchAccountAction.qrLogin: _qrLogin,
    SwitchAccountAction.clearAccount: _onClearAccount,
    Lifecycle.initState: _initData,
  });
}

void _initData(Action action, Context<SwitchAccountState> ctx) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  ctx.state.versionStr = packageInfo.version;
  ctx.dispatch(SwitchAccountActionCreator.onGetVersion());
  var localUserInfoList = await LocalUserStore().getUserList();
  ctx.dispatch(
      SwitchAccountActionCreator.onLocalUserGetOkay(localUserInfoList));
  
  Future.delayed(Duration(milliseconds: 200),(){
    //eaglePage(ctx.state.selfId(),
          //sourceId: ctx.state.eagleId(ctx.context));
  });
}

void _onClearAccount(Action action, Context<SwitchAccountState> ctx) async {
  await LocalUserStore().clean();
  // state.localUserInfoList = <LocalUserInfo>[];
  await netManager.setToken(null);
  await GlobalStore.loginByDevice(await getDeviceId());
  var localUserInfoList = await LocalUserStore().getUserList();
  ctx.dispatch(
      SwitchAccountActionCreator.onLocalUserGetOkay(localUserInfoList));
  showToast(msg: Lang.CLEAR_COMPLETE);
}

///进入客服
void _onService(Action action, Context<SwitchAccountState> ctx) async {
  csManager.openServices(ctx.context);
}

void _deviceLogin(Action action, Context<SwitchAccountState> ctx) async {
  String deviceId = await getDeviceId();
  if (TextUtil.isEmpty(deviceId)) {
    showToast(msg: "设备号为空");
    l.e("switch_account", 'device id is empty');
    return;
  }
  // 删除旧的toekn
  await netManager.setToken(null);
  // 刷新ua
  netManager.userAgent(deviceId);
  var userInfo = await GlobalStore.loginByDevice(deviceId);
  if (null == userInfo) {
    showToast(msg: "切换账号失败");
    return;
  }
  _handleLoginSuccess(action, ctx, userInfo);
}

void _qrLogin(Action action, Context<SwitchAccountState> ctx) async {
  String qr = action.payload;
  if (TextUtil.isEmpty(qr)) {
    showToast(msg: "二维码为空");
    l.e("switch_account", 'qrcode is empty');
    return;
  }
  // 删除旧的toekn
  await netManager.setToken(null);
  // 刷新ua
  netManager.userAgent(await getDeviceId());
  var userInfo = await GlobalStore.loginByQr(qr);
  if (null == userInfo) {
    showToast(msg: "切换账号失败");
    return;
  }
  _handleLoginSuccess(action, ctx, userInfo);
}

_handleLoginSuccess(Action action, Context<SwitchAccountState> ctx,
    UserInfoModel userInfo) async {
  Navigator.pushNamedAndRemoveUntil(
    ctx.context,
    PAGE_HOME,
    (route) => route == null,
  );
}
