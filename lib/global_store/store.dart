import 'dart:io';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_store/local_user_store.dart';
import 'package:flutter_app/common/net/code.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/msg_count_model.dart';
import 'package:flutter_app/model/user/local_user_info.dart';
import 'package:flutter_app/model/user/mobile_login_model.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'action.dart';
import 'reducer.dart';
import 'package:dio/dio.dart';
import 'state.dart';

/// 建立一个AppStore
/// 目前它的功能只有切换主题
class GlobalStore {
  static Store<GlobalState> _globalStore;

  static Store<GlobalState> get store => _globalStore ??=
      createStore<GlobalState>(initState(null), buildReducer());

  static bool isMe(int uid) {
    return (GlobalStore.store?.getState()?.meInfo?.uid ?? 0) == uid;
  }

  ///查询需要权限
  ///type定义
  /*
2 发表评论
3 更换头像
4 使用相册
5 修改个性签名
7 下载超清原图
13 下载视频
  */
  static bool checkPermissions(int type) {
    if ((GlobalStore.store?.getState()?.wallet?.privilegeBeans?.length ?? 0) ==
        0) {
      return false;
    }
    var data = (GlobalStore.store?.getState()?.wallet?.privilegeBeans ?? [])
        .firstWhere((element) => ((element.type == type) && element.enable),
            orElse: () => null);
    return data != null;
  }

  ///是否充值vip（不包括推广）
  static bool isRechargeVIP() {
    return (GlobalStore.store?.getState()?.meInfo?.isVip ?? false) &&
        (GlobalStore.store?.getState()?.meInfo?.vipLevel ?? 0) > 0;
  }

  ///是否充值vip（不包括推广）
  static bool isRechargeVIPNew() {
    return (GlobalStore.store?.getState()?.meInfo?.isVip ?? false) &&
        (GlobalStore.store?.getState()?.meInfo?.vipLevel ?? 0) > 0 &&
        (GlobalStore.store?.getState()?.wallet?.consumption ?? 0) > 0;
  }

  ///vip（包括推广）
  static bool isVIP() {
    // return (GlobalStore.store?.getState()?.meInfo?.isVip ?? false);
    return (GlobalStore.store?.getState()?.meInfo?.isVip ?? false) &&
        (GlobalStore.store?.getState()?.meInfo?.vipLevel ?? 0) > 0;
  }

  static UserInfoModel getMe() {
    return GlobalStore.store?.getState()?.meInfo;
  }

  static WalletModelEntity getWallet() {
    return GlobalStore.store?.getState()?.wallet;
  }

  /// 更新城市
  // static updateCity(String city) {
  //   final UserInfoModel userInfo = GlobalStore.store?.getState()?.meInfo;
  //   if (null != userInfo) {
  //     userInfo.city = city;
  //     _globalStore.dispatch(GlobalActionCreator.userUpdateOkay(userInfo));
  //   }
  // }
  /// 刷新钱包信息
  static Future<WalletModelEntity> refreshWallet([bool refresh = true]) async {
    WalletModelEntity wallet;
    try {
      wallet = await netManager.client.getWallet();
    } catch (e) {
      l.e("wallet", "refreshWallet()...error:$e");
    }
    if (null != wallet && refresh)
      _globalStore.dispatch(GlobalActionCreator.walletUpdateOkay(wallet));
    return wallet;
  }


  /// 刷新视频下载数量
  static Future<WalletModelEntity> refreshWalletOnlyDownloadCount(WalletModelEntity wallet) async {
    if(wallet==null){
      return wallet;
    }
   _globalStore.dispatch(GlobalActionCreator.walletUpdateOkay(wallet));
    return wallet;
  }

  /// 二维码登陆
  /// [refresh] 是否刷新关联globalstate的状态的页面 ==false就只是一个网络请求了
  static Future<UserInfoModel> loginByQr(String qr,
      [String paste = "", bool refresh = true]) async {
    String devType = await getDevType();
    UserInfoModel userInfo;
    String buildID = await netManager.getFixedPkgName();
    try {
      userInfo = await netManager.client.devLogin("", qr, devType,
          Platform.operatingSystem, Config.innerVersion, buildID, "", paste);
    } catch (e) {
      l.e("loginQr", "error:$e");
    }
    if (TextUtil.isNotEmpty(userInfo?.token)) {
      netManager.setToken(userInfo.token);
    }
    if (null != userInfo) {
      if (userInfo.loginType != 1) {
        await LocalUserStore().addUser(LocalUserInfo(
            uid: userInfo.uid,
            nickName: userInfo.name,
            mobile: userInfo.mobile,
            portrait: userInfo.portrait,
            qr: qr,
            loginType: userInfo.loginType));
      }
      if (refresh)
        _globalStore.dispatch(GlobalActionCreator.userUpdateOkay(userInfo));
    }
    return userInfo;
  }

  /// 设备登陆
  /// [refresh] 刷新所有user全局状态
  static Future<UserInfoModel> loginByDevice(String deviceId,
      [String paste = "", bool refresh = true]) async {
    String devType = await getDevType();
    UserInfoModel userInfo;
    String buildID = await netManager.getFixedPkgName();
    var deviceIdSign = Config.getDevToken(deviceId);
    try {
      userInfo = await netManager.client.devLogin(
        deviceId,
        "",
        devType,
        Platform.operatingSystem,
        Config.innerVersion,
        buildID,
        deviceIdSign,
        paste,
      );
    } on DioError catch (e) {
      var error = e.error;
      if (error is ApiException) {
        if (error.code == Code.ACCOUNT_INVISIBLE) {
          ///这处理是因为在封号的情况下不重复弹窗
          return UserInfoModel();
        }
      }
      l.d('loginByDevice', e.toString());
    } catch (e) {
      l.e("logindeviceId", "error:$e");
    }
    if (TextUtil.isNotEmpty(userInfo?.token)) {
      await netManager.setToken(userInfo.token);
    }
    if (null != userInfo) {
      if (userInfo.loginType != 1) {
        await LocalUserStore().addUser(LocalUserInfo(
            uid: userInfo.uid,
            nickName: userInfo.name,
            mobile: userInfo.mobile,
            portrait: userInfo.portrait,
            qr: "",
            loginType: userInfo.loginType));
      }
      if (refresh)
        _globalStore.dispatch(GlobalActionCreator.userUpdateOkay(userInfo));
    }
    return userInfo;
  }

  /// 手机号码登陆
  /// [refresh] 刷新所有user全局状态
  static Future<UserInfoModel> mobileLogin(String mobile, String code,
      [String paste = "", bool refresh = true]) async {
    String devType = await getDevType();
    String buildID = await netManager.getFixedPkgName();
    String deviceID = await getDeviceId();
    MobileLoginModel mobileModel;
    try {
      mobileModel = await netManager.client.mobileLogin(
          mobile,
          code,
          deviceID,
          devType,
          Platform.operatingSystem,
          Config.innerVersion,
          buildID,
          paste);
    } catch (e) {
      l.e("mobileLogin", "error:$e");
    }
    if (TextUtil.isNotEmpty(mobileModel?.userInfo?.token)) {
      netManager.setToken(mobileModel.userInfo.token);
    }
    if (null != (mobileModel?.userInfo ?? null)) {
      var userInfo = mobileModel.userInfo;
      if (userInfo.loginType != 1) {
        await LocalUserStore().addUser(LocalUserInfo(
            uid: userInfo.uid,
            nickName: userInfo.name,
            mobile: userInfo.mobile,
            portrait: userInfo.portrait,
            qr: "",
            loginType: userInfo.loginType));
      }
      if (refresh)
        _globalStore
            .dispatch(GlobalActionCreator.userUpdateOkay(mobileModel.userInfo));
    }
    return mobileModel?.userInfo;
  }

  /// 组合业务，更新用户信息并获取用户新的信息
  /// 如果map为空就是单纯的获取用户信息
  /// [refresh] 刷新所有user全局状态
  static Future<UserInfoModel> updateUserInfo(Map<String, dynamic> map,
      [bool refresh = true]) async {
    UserInfoModel userInfo;
    l.e("updateUser", "begin udpate user...${map}");
    try {
      if ((map?.keys?.length ?? 0) > 0) {
        var result = await netManager.client.updateUserInfo(map);
        if (null == result) return null;
      }

      userInfo = await netManager.client.getUserInfo();
    } catch (e) {
      l.e("updateUser", "updateUserInfo()...error:$e");
    }
    if (null != userInfo) {
      LocalUserStore().addUser(LocalUserInfo(
          uid: userInfo.uid,
          nickName: userInfo.name,
          mobile: userInfo.mobile,
          portrait: userInfo.portrait,
          qr: ""));
      if (refresh)
        _globalStore.dispatch(GlobalActionCreator.userUpdateOkay(userInfo));
    }
    return userInfo;
  }

}
