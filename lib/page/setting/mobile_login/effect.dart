import 'dart:convert' as convert;
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/can_play_count_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/local_video_model.dart';
import 'package:flutter_app/model/watch_count_model.dart';
import 'package:flutter_app/page/video/video_list_model/recommend_list_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';

import 'action.dart';
import 'state.dart';

Effect<MobileLoginState> buildEffect() {
  return combineEffects(<Object, Effect<MobileLoginState>>{
    MobileLoginAction.getSMSCodeAction: _sendSMSCode,
    MobileLoginAction.phoneLoginAction: _phoneLogin,
    Lifecycle.initState: _initState,
  });
}

void _sendSMSCode(Action action, Context<MobileLoginState> ctx) {
  sendSMSCode(ctx, action.payload);
}

bool isMaJiaAccount(Context<MobileLoginState> ctx) {
  if (ctx.state.areaCode == "86" &&
      ctx.state.phoneController.text.replaceAll(" ", "").startsWith("122")) {
    return true;
  }
  return false;
}

//验证手机号是否正确
Future<bool> parsePhoneNumber(Context<MobileLoginState> ctx) async {
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

String getFullPhone(Context<MobileLoginState> ctx) {
  //拼接区号和手机号
  var resultMobile = "+${ctx.state.areaCode ?? 86}".replaceAll(" ", "") +
      ctx.state.phoneController.text.replaceAll(" ", "");
  if (ctx.state.areaCode != null || (ctx.state.areaCode?.isNotEmpty ?? false)) {
    resultMobile = "+" +
        ctx.state.areaCode.replaceAll(" ", "") +
        ctx.state.phoneController.text.replaceAll(" ", "");
  }
  return resultMobile;
}

bool verifyInput(Context<MobileLoginState> ctx) {
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

void _initState(Action action, Context<MobileLoginState> ctx) async {
  //验证手机号
  String mobile = ctx.state.phoneController.value.text;
  if (mobile == null || mobile.isEmpty) {
    return;
  }
  try {
    final parsed = await ctx.state.phoneNumberMgr.parse(mobile);
    if (parsed != null) {
      mobile = parsed['national'];
      ctx.dispatch(MobileLoginActionCreator.onShowArea(parsed['country_code']));
    }
    ctx.state.phoneController.text = mobile;
  } catch (e) {
    ctx.state.phoneController.text = "";
  }
  Future.delayed(Duration(milliseconds: 200), () {
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

void _phoneLogin(Action action, Context<MobileLoginState> ctx) async {
  if (ClickUtil.isFastClick()) {
    return;
  }
  if (ctx.state.isLogging) {
    return;
  }

  if (ctx.state.phoneController.text == null ||
      ctx.state.phoneController.text.isEmpty) {
    showToast(msg: Lang.PLEASE_INPUT_PHONE, gravity: ToastGravity.CENTER);
    return;
  }

  /*bool res = await parsePhoneNumber(ctx);
  if (!res) {
    showToast(msg: Lang.PHONE_FORMAT_ERROR, gravity: ToastGravity.CENTER);
    return;
  }*/

  if (!verifyInput(ctx)) return;
  var resultMobile = getFullPhone(ctx);
  ctx.state.isLogging = true;
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

  _mobileLogin(
    ctx,
    params['devID'],
    params['mobile'],
    params['code'],
    params['smsId'],
    params['sysType'],
    params['ver'],
    params['devType'],
    params['buildID'],
  );
}

///发送验证码
sendSMSCode(Context<MobileLoginState> ctx, String phoneNum) async {
  // Map<String, dynamic> mapList = Map();
  // mapList['mobile'] = phoneNum;
  // BaseResponse res =
  //     await HttpManager().post(Address.SEND_SMS, params: mapList);
  try {
    await netManager.client.postSendSms(phoneNum);
    ctx.dispatch(MobileLoginActionCreator.onGetSMSCode(true));
  } catch (e) {
    l.e('postSendSms=', e.toString());
    showToast(msg: e.msg ?? '', gravity: ToastGravity.CENTER);
  }
  // if (res.code == 200) {
  //   ctx.dispatch(MobileLoginActionCreator.onGetSMSCode(true));
  // } else {
  //   showToast(msg: res.msg ?? '', gravity: ToastGravity.CENTER);
  // }
}

///手机号登录
_mobileLogin(
    Context<MobileLoginState> ctx,
    String devID,
    String phoneNum,
    String code,
    String smsId,
    String sysType,
    String ver,
    String devType,
    String applicationID) async {
  var userInfo = await GlobalStore.mobileLogin(phoneNum, code);
  if (null == userInfo) {
    // await showConfirm(ctx.context, title: Lang.NET_CANT_REACH_TIP);
    ctx.dispatch(MobileLoginActionCreator.onPhoneLogin());
    // showToast(msg: "登陆失败");
    return;
  }
  showToast(msg: Lang.PHONE_LOGIN_SUCCESS, gravity: ToastGravity.CENTER);

  // FIXME 很丑的代码
  await _playCount(ctx.context);
  await _pullRecommendVideo(ctx.context);
}

///非VIP用户 播放次数控制
_playCount(BuildContext context) async {
  ///获取播放次数
  if (TextUtil.isNotEmpty(GlobalStore.getMe()?.vipExpireDate) ?? false) {
    DateTime dateTime = DateTime.parse(GlobalStore.getMe()?.vipExpireDate);
    if (dateTime.isAfter(netManager.getFixedCurTime())) {
      return;
    }
  }
  try {
    WatchCount watchObj = await netManager.client.getPlayStatus();
    // Provider.of<PlayCountModel>(context, listen: false)
    //     .setPlayCnt(watchObj?.watchCount ?? 0);
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

///拉取推荐视频
_pullRecommendVideo(BuildContext context) async {
  ///拉取推荐视频
  var list = await recommendListModel.refreshList();
  if (ArrayUtil.isEmpty(list)) {
    // showToast(msg: Lang.PRELOAD_ERROR);
  }
  safePopPage();
  Navigator.pushNamedAndRemoveUntil(
      context, PAGE_HOME, (route) => route == null);
}
