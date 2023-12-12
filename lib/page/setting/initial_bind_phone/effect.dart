import 'dart:io';
import 'dart:convert' as convert;

import 'package:device_info/device_info.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/country.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/can_play_count_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/country_code_entity.dart';
import 'package:flutter_app/model/local_video_model.dart';
import 'package:flutter_app/model/watch_count_model.dart';
import 'package:flutter_app/page/home/page.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:package_info/package_info.dart';

import 'action.dart';
import 'state.dart';

Effect<InitialBindPhoneState> buildEffect() {
  return combineEffects(<Object, Effect<InitialBindPhoneState>>{
    InitialBindPhoneAction.sendSMSCodeAction: _onGetSMSCode,
    InitialBindPhoneAction.onClickNextStep: _onClickNextStep,
    InitialBindPhoneAction.showCountryCodeUI: _showCountryCodeUI,
    Lifecycle.initState: _init,
    Lifecycle.dispose: _dispose,
  });
}

void _init(Action action, Context<InitialBindPhoneState> ctx) {
  ///绑定手机类型 0 绑定手机号 1更换手机号 2账号找回-更换绑定手机号
  int bindMobileType = ctx.state.bindMobileType ?? 0;
  l.e("---->", "当前更换手机号类型:$bindMobileType");
  if (bindMobileType == 2) {
    ctx.state.phoneController.text = ctx.state.mobileNum ?? "";
  }
}

///发送验证码
void _onGetSMSCode(Action action, Context<InitialBindPhoneState> ctx) async {
  String phoneCode = ctx.state.phoneCode ?? "+86";
  String phoneNum = ctx.state.phoneController?.text?.trim();
  if (ctx.state.phoneController.text == null ||
      ctx.state.phoneController.text.isEmpty) {
    showToast(msg: Lang.PLEASE_INPUT_PHONE);
    return;
  }

  ///1-绑定手机号 2-手机号登陆
  int smsType = ctx.state.bindMobileType == 2 ? 2 : 1;
  String newPhoneNum = "$phoneCode$phoneNum".replaceAll(" ", "");
  var result = await netManager.client.postNotificationSms(newPhoneNum, smsType);
  l.e("发送验证码-result:", "$result");

  showToast(msg: "发送验证码成功~");
  ctx.dispatch(InitialBindPhoneActionCreator.onSendSMSCode(true));
}

///绑定手机类型 0 绑定手机号 1更换手机号 2账号找回-更换绑定手机号
Future<void> _onClickNextStep(
    Action action, Context<InitialBindPhoneState> ctx) async {
  if (ctx.state.bindMobileType == 0 || ctx.state.bindMobileType == 1) {
    //绑定手机号 更换手机号
    _executeBindingPhone(action, ctx);
  } else if (ctx.state.bindMobileType == 2) {
    //账号找回-获取验证码后，直接登录，刷新用户信息
    _executeLoginByPhone(action, ctx);
  }
}

///执行绑定手机号
Future<void> _executeBindingPhone(
    Action action, Context<InitialBindPhoneState> ctx) async {
  if (ClickUtil.isFastClick()) {
    return;
  }

  try {
    if (ctx.state.phoneController.text == null ||
        ctx.state.phoneController.text.isEmpty) {
      showToast(msg: Lang.PLEASE_INPUT_PHONE);
      return false;
    }
    String verifyCode = ctx.state.smsCodeController?.text?.trim();
    if (verifyCode == null || verifyCode.isEmpty) {
      showToast(msg: Lang.VERTICAL_ERROR);
      return false;
    }

    String phoneCode = ctx.state.phoneCode ?? "+86";
    String phoneNum = ctx.state.phoneController?.text?.trim();
    String newPhoneNum = "$phoneCode$phoneNum".replaceAll(" ", "");

    var result = await netManager.client.postBindPhone(newPhoneNum, verifyCode);
    l.e("绑定手机号-result:", "$result");

    ///关闭界面，更新用户信息, 进入修改成功UI
    safePopPage();

    GlobalStore.updateUserInfo(null);
    JRouter()
        .jumpPage(BINDING_PHONE_SUCCESS, args: {"newPhoneNum": newPhoneNum});
  } catch (e) {
    showToast(msg: "绑定手机号失败：\n$e");
  }
}

//发送验证码
//https://wbsqht.cestalt.com/api/app/notification/captcha
//mobile: "+8613111234065"
// type: 1

//绑定成功
//https://wbsqht.cestalt.com/api/app/mine/mobileBind
//code: "1234"
// mobile: "+8613111234065"

//更新用户信息

//绑定成功UI--> 换绑定UI

//账号找回 -> 发送验证码->调用登录接口-登录替换用户信息

///展示国家code列表弹出框
void _showCountryCodeUI(
    Action action, Context<InitialBindPhoneState> ctx) async {
  List<CountryCodeList> codeList = await getCountryCodes();

  showCountryCodeDialogUI(ctx.context, codeList, (code) {
    ctx.state.phoneCode = code;
    ctx.dispatch(InitialBindPhoneActionCreator.updateUI());
  });
}

///执行手机登录
Future<void> _executeLoginByPhone(
    Action action, Context<InitialBindPhoneState> ctx) async {
  if (ClickUtil.isFastClick()) {
    return;
  }

  try {
    if (ctx.state.phoneController.text == null ||
        ctx.state.phoneController.text.isEmpty) {
      showToast(msg: Lang.PLEASE_INPUT_PHONE);
      return false;
    }
    String verifyCode = ctx.state.smsCodeController?.text?.trim();
    if (verifyCode == null || verifyCode.isEmpty) {
      showToast(msg: Lang.VERTICAL_ERROR);
      return false;
    }

    String phoneCode = ctx.state.phoneCode ?? "+86";
    String phoneNum = ctx.state.phoneController?.text?.trim();
    String newPhoneNum = "$phoneCode$phoneNum".replaceAll(" ", "");

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
      params['mobile'] = newPhoneNum;
      params['code'] = ctx.state.smsCodeController.text;
      params['smsId'] = "";
      params['sysType'] = androidInfo?.model ?? "";
      params['ver'] = (await PackageInfo.fromPlatform()).version;
      params['devType'] = androidInfo?.device ?? "";
      params['buildID'] = packageInfo.packageName;
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin?.iosInfo;
      params["devID"] = await getDeviceId();
      params['mobile'] = newPhoneNum;
      params['code'] = ctx.state.smsCodeController.text;
      params['smsId'] = "";
      params["sysType"] = iosInfo?.systemName ?? "";
      params["ver"] = (await PackageInfo.fromPlatform()).version;
      params["devType"] = iosInfo?.name ?? "";
      params['buildID'] = packageInfo.packageName;
    }
    var userInfo = await GlobalStore.mobileLogin(phoneNum, verifyCode);
    if (null == userInfo) {
      showToast(msg: "登陆失败", gravity: ToastGravity.CENTER);
      return;
    }
    showToast(msg: Lang.PHONE_LOGIN_SUCCESS, gravity: ToastGravity.CENTER);

    GlobalStore.refreshWallet();
    await _playCount(ctx.context);
    safePopPage();

    ///返回主页
    // Gets.Get.offAll(HomePage());
  } catch (e) {
    l.e("登录失败", "$e");
    showToast(msg: "登录失败 $e", gravity: ToastGravity.CENTER);
  }
}

///非VIP用户 播放次数控制
Future _playCount(BuildContext context) async {
  ///获取播放次数
  if (TextUtil.isNotEmpty(GlobalStore.getMe()?.vipExpireDate) ?? false) {
    DateTime dateTime = DateTime.parse(GlobalStore.getMe()?.vipExpireDate);
    if (dateTime.isAfter(netManager.getFixedCurTime())) {
      return;
    }
  }
  try {
    WatchCount watchObj = await netManager.client.getPlayStatus();
    playCountModel.setPlayCnt(watchObj?.watchCount ?? 0);
    String result = await lightKV.getString(Config.LOOKED_VIDEO_LIST);
    if (result != null && result.isNotEmpty) {
      List<dynamic> lookedVideoList = convert.jsonDecode(result);
      int day = (netManager.getFixedCurTime()).day;
      lookedVideoList.forEach((model) {
        LocalVideoModel localVideoModel = LocalVideoModel.fromMap(model);
        if (localVideoModel.day == day) {
          VariableConfig.playedVideoList.add(localVideoModel);
        }
      });
      await lightKV.setString(Config.LOOKED_VIDEO_LIST,
          convert.jsonEncode(VariableConfig.playedVideoList));
    }
  } catch (e) {
    l.d('getPlayStatus', e.toString());
    showToast(msg: Lang.COUNT_GET_ERROR, gravity: ToastGravity.CENTER);
  }
}

void _dispose(Action action, Context<InitialBindPhoneState> ctx) {
  ctx.state.phoneController?.dispose();
  ctx.state.smsCodeController?.dispose();
}
