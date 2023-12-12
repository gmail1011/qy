import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:package_info/package_info.dart';
import 'CustomHttpClientAdapter.dart';
import 'client_api.dart';
import 'http_header_interceptor.dart';
import 'http_log_interceptor.dart';
import 'http_resp_interceptor.dart';
import 'http_signature_interceptor.dart';

/// 连接超时15秒
const int CONNECT_TIME_OUT = 15 * 1000;

final netManager = NetManager();

class NetManager {
  Dio _clientDio;
  // Dio _bankDio;
  static bool _inited = false;
  ClientApi client;
  // BankApi bankApi;
  init(String baseUrl) {
    _clientDio = createDio(
        options:
            BaseOptions(connectTimeout: CONNECT_TIME_OUT, baseUrl: baseUrl),
        mainThread: false);
    _clientDio.interceptors.add(HttpHeaderInterceptor());
    _clientDio.interceptors.add(SignatureInterceptor());
    _clientDio.interceptors.add(HttpLogInterceptor());
    _clientDio.interceptors.add(HttpRespInterceptor());
    if(Config.DNS_CUSTOM && TextUtil.isNotEmpty(Config.DNS_IP)){
      _clientDio.httpClientAdapter = CustomHttpClientAdapter(Config.DNS_IP);
    }
    _inited = true;
    client = ClientApi(_clientDio);
    // bankApi = BankApi(_bankDio);
  }
  reset(){
    netManager.init(Address.baseApiPath);
  }

  static bool get isInited => _inited;

  Future<String> getToken() async {
    var token = (await lightKV.getString("_key_net_token")) ?? '';
    // token = token.substring(10);
    return token;
  }

  Future<bool> setToken(String token) async {
    // 该key不共享，不放全局变量
    return lightKV.setString("_key_net_token", token);
  }

  /// deviceId 不为空的话，表示切换一次设备；
  Future<String> userAgent([String deviceId]) async {
    String oldUa = (await lightKV.getString("_key_user_agent")) ?? '';
    if (TextUtil.isEmpty(deviceId) && TextUtil.isNotEmpty(oldUa)) {
      return oldUa;
    }
    String newUa = (await _genUserAgent(deviceId)) ?? '';
    if (TextUtil.isNotEmpty(newUa)) lightKV.setString("_key_user_agent", newUa);
    return newUa;
  }

  /// 清除ua
  Future<bool> clearUserAgent() {
    return lightKV.setString("_key_user_agent", null);
  }

  Future<String> _genUserAgent([String deviceId]) async {
    if (TextUtil.isEmpty(deviceId)) {
      deviceId = await getDeviceId();
    }

    String devType = await getDevType();
    String sysType = Platform.operatingSystem;

    String ver = Config.innerVersion;
    String buildID = await getFixedPkgName();
    String ua = Uri.encodeComponent(
        "DevID=$deviceId;DevType=$devType;SysType=$sysType;Ver=$ver;BuildID=$buildID;Mac=${Config.macAddress};GlobalDevID=${Config.imei}");
    return ua;
  }

  /// 获取修正后的pkgName
  Future<String> getFixedPkgName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isIOS) {
      return Config.IOS_TF_BUNDLE_ID;
    } else {
      return packageInfo.packageName;
    }
  }

  /// 服务器时间
  DateTime _serverTime;

  /// 服务器时间和本地时间的差值
  int _diffTimeInSeconds = 0;

  /// 获取上一次服务器返回的时间
  DateTime getServerTime() {
    if (null != _serverTime) {
      return _serverTime;
    } else {
      return DateTime.now();
    }
  }

  /// 设置服务器时间
  void setServerTime(String serverTimeS) {
    if (TextUtil.isNotEmpty(serverTimeS)) {
      _serverTime = DateTime.parse(serverTimeS);
      _diffTimeInSeconds = DateTime.now().difference(_serverTime).inSeconds;
      print(
          "====================>server diff from local in seconds:$_diffTimeInSeconds");
    }
  }

  // 获取服务器时间
  Future<String> getReqDate() async {
    String reqDate;
    try {
      reqDate = (await netManager.client.getReqDate()).sysDate;
    } catch (e) {
      l.e("tag", "_onRefresh()...error:$e");
    }
    if (TextUtil.isEmpty(reqDate)) {
      reqDate = (netManager.getFixedCurTime().toString());
    }
    return reqDate;
  }

  /// 获取修复后的本地时间,应该是和服务器时间是同步的
  DateTime getFixedCurTime() {
    return DateTime.now().add(Duration(seconds: -_diffTimeInSeconds));
  }
}
