import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';

import 'action.dart';
import 'state.dart';

Effect<RebindPhoneState> buildEffect() {
  return combineEffects(<Object, Effect<RebindPhoneState>>{
    RebindPhoneAction.getSMSCodeAction: _sendSMSCode,
    RebindPhoneAction.bindPhoneAction: _rebindPhone,
    RebindPhoneAction.onRebindPhone: _onRebindPhone,
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<RebindPhoneState> ctx){
  
  Future.delayed(Duration(milliseconds: 200),(){
    //eaglePage(ctx.state.selfId(),
        //  sourceId: ctx.state.eagleId(ctx.context));
  });
}

void _sendSMSCode(Action action, Context<RebindPhoneState> ctx) {
  sendSMSCode(ctx, action.payload);
}

Future<void> _onRebindPhone(
    Action action, Context<RebindPhoneState> ctx) async {
  if (ClickUtil.isFastClick()) {
    return;
  }

  if (ctx.state.phoneController.text == null ||
      ctx.state.phoneController.text.isEmpty) {
    showToast(msg: Lang.PLEASE_INPUT_PHONE, gravity: ToastGravity.CENTER);
    return;
  }

  /*var res = await parsePhoneNumber(ctx);
  if (!res) {
    showToast(msg: Lang.PHONE_FORMAT_ERROR, gravity: ToastGravity.CENTER);
    return;
  }*/

  var resultMobile = "+86" + ctx.state.phoneController.text;
  if (ctx.state.phoneCode != null || ctx.state.phoneCode.isNotEmpty) {
    resultMobile = "+" + ctx.state.phoneCode + ctx.state.phoneController.text;
  }

  if (!verifyInput(ctx)) return;
  if (ctx.state.isBinding) {
    return;
  }
  ctx.state.isBinding = true;
  Map<String, dynamic> params = {};
  DeviceInfoPlugin deviceInfoPlugin;
  try {
    deviceInfoPlugin = DeviceInfoPlugin();
  } catch (e) {
    l.e("device", "deviceInfo:$e");
  }
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  if (Platform.isAndroid) {
    var androidInfo = await deviceInfoPlugin?.androidInfo;
    params['devID'] = await getDeviceId();
    params['mobile'] = resultMobile;
    params['code'] = ctx.state.smsCodeController.text;
    params['smsId'] = "";
    params['sysType'] = androidInfo?.model ?? "";
    params['ver'] = (await PackageInfo.fromPlatform()).version;
    params['devType'] = androidInfo?.device ?? "";
    params['buildID'] = packageInfo.packageName;
  } else if (Platform.isIOS) {
    var iosInfo = await deviceInfoPlugin?.iosInfo;
    params["devID"] = await getDeviceId();
    params['mobile'] = resultMobile;
    params['code'] = ctx.state.smsCodeController.text;
    params['smsId'] = "";
    params["sysType"] = iosInfo?.systemName ?? "";
    params["ver"] = (await PackageInfo.fromPlatform()).version;
    params["devType"] = iosInfo?.name ?? "";
    params['buildID'] = packageInfo.packageName;
  }
  ctx.dispatch(RebindPhoneActionCreator.bindPhone(params));
}

bool verifyInput(Context<RebindPhoneState> ctx) {
//    if (state.phoneController.text == null ||
//        state.phoneController.text.isEmpty) {
//      showToast(msg: '请填写手机号');
//      return false;
//    }
//    if (!isChinaPhoneLegal(state.phoneController.text)) {
//      showToast(msg: '手机号格式有误');
//      return false;
//    }
  if (ctx.state.smsCodeController.text == null ||
      ctx.state.smsCodeController.text.isEmpty) {
    showToast(
        msg: Lang.PLEASE_INPUT_VERTICAL_CODE, gravity: ToastGravity.CENTER);
    return false;
  }
  if (!TextUtil.isSMSCode(ctx.state.smsCodeController.text)) {
    showToast(msg: Lang.VERTICAL_ERROR, gravity: ToastGravity.CENTER);
    return false;
  }
  return true;
}

String getFullPhone(Context<RebindPhoneState> ctx) {
  //拼接区号和手机号
  var resultMobile = ctx.state.phoneCode ??
      "86" + ctx.state.phoneController.text.replaceAll(" ", "");
  if (ctx.state.phoneCode != null ||
      (ctx.state.phoneCode?.isNotEmpty ?? false)) {
    resultMobile = "+" +
        ctx.state.phoneCode.replaceAll(" ", "") +
        ctx.state.phoneController.text.replaceAll(" ", "");
  }
  return resultMobile;
}

bool isMaJiaAccount(Context<RebindPhoneState> ctx) {
  if (ctx.state.phoneCode == "86" &&
      ctx.state.phoneController.text.replaceAll(" ", "").startsWith("122")) {
    return true;
  }
  return false;
}

//验证手机号是否正确
Future<bool> parsePhoneNumber(Context<RebindPhoneState> ctx) async {
  if (isMaJiaAccount(ctx)) {
    return Future.value(true);
  }
  //拼接区号和手机号
  var resultMobile = getFullPhone(ctx);
  try {
    //验证手机号
    final parsed = await ctx.state.phoneNumberMgr.parse(resultMobile);
    if (parsed != null) {
      return Future.value(true);
    }
  } catch (e) {
    return Future.value(false);
  }
  return Future.value(false);
}

void _rebindPhone(Action action, Context<RebindPhoneState> ctx) {
  _bindPhone(
    ctx,
    action.payload['devID'],
    action.payload['mobile'],
    action.payload['code'],
    action.payload['smsId'],
    action.payload['sysType'],
    action.payload['ver'],
    action.payload['devType'],
    action.payload['buildID'],
  );
}

///发送验证码
sendSMSCode(Context<RebindPhoneState> ctx, String phoneNum) async {
  // Map<String, dynamic> mapList = Map();
  // mapList['mobile'] = phoneNum;
  // mapList['type'] = 1;

  // ///type int 1-绑定手机号。2-使用手机号登陆
  // BaseResponse res =
  //     await HttpManager().post(Address.SEND_SMS, params: mapList);
  try {
    await netManager.client.postSendSms(phoneNum, 1);
    ctx.dispatch(RebindPhoneActionCreator.onGetSMSCode(true));
  } catch (e) {
    l.e('postSendSms', e.toString());
    showToast(msg: e.msg ?? '');
  }
  // if (res.code == 200) {
  //   ctx.dispatch(RebindPhoneActionCreator.onGetSMSCode(true));
  // } else {
  //   showToast(msg: res.msg ?? '');
  // }
}

///绑定手机号
_bindPhone(
    Context<RebindPhoneState> ctx,
    String devID,
    String phoneNum,
    String code,
    String smsId,
    String sysType,
    String ver,
    String devType,
    String applicationID) async {
  // Map<String, dynamic> mapList = Map();
  // mapList['mobile'] = phoneNum;
  // mapList['code'] = code;
  // mapList['devID'] = devID;
  // mapList['smsId'] = smsId;
  // mapList['sysType'] = sysType;
  // mapList['ver'] = ver;
  // mapList['devType'] = devType;
  // mapList['buildID'] = applicationID;
  try {
    ctx.state.isBinding = false;
    await netManager.client.postBindPhoneNew(phoneNum, code, devID, smsId, sysType, ver, devType, applicationID);
    GlobalStore.updateUserInfo(null);
    showToast(msg: Lang.BIND_PHONE_SUCCESS, gravity: ToastGravity.CENTER);
    safePopPage();
  } catch (e) {
    l.e('postBindPhoneNew', e.toString());
    showToast(msg: Lang.BIND_ERROR, gravity: ToastGravity.CENTER);
  }
  // String action = Address.BIND_PHONE_NEW;
  // BaseResponse res = await HttpManager().post(action, params: mapList);
  // ctx.state.isBinding = false;

  // if (res.code == 200) {
  //   GlobalStore.updateUserInfo(null);
  //   showToast(msg: Lang.BIND_PHONE_SUCCESS, gravity: ToastGravity.CENTER);
  //   safePopPage();
  // } else {
  //   showToast(msg: Lang.BIND_ERROR, gravity: ToastGravity.CENTER);
  // }
}
