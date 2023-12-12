import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/net/code.dart';
import 'package:flutter_app/common/net/interceptors/response_interceptor.dart';
import 'package:flutter_app/common/net2/base_resp_bean.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/dailog_global.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'api_exception.dart';
import 'net_manager.dart';

/// 响应拦截器=>返回数据转换
class HttpRespInterceptor extends InterceptorsWrapper {
  static const String TAG = "HttpRespInterceptor";
  HttpRespInterceptor();
  @override
  Future onResponse(Response response) async {
    return handleResponse(response);
  }

  @override
  onError(DioError err) async {
    debugLog("resp_interceptor:" +
        'onError()...path:${err?.request?.path} url:${err?.request?.uri?.toString()} err:${err?.toString()}',);
    return Future.value(err);
  }

  static Future<dynamic> handleResponse(Response response) async {
    if (null == response) {
      return Future.error(ApiException(-200, "response is null"));
    }
    if (response.statusCode != 200) {
      return Future.error(
          ApiException(response.statusCode, "statusCode is not 200"));
    }
    BaseRespBean baseResp;
    if (response.data is Map) {
      baseResp = BaseRespBean.fromJson(response.data);
    } else if (response.data is String) {
      baseResp = BaseRespBean.fromJson(json.decode(response.data));
    } else {
      return Future.error(
          ApiException(Code.PARSE_DATE_ERROR, Lang.PARSE_DATE_ERROR));
    }

    netManager.setServerTime(baseResp.time);
    int code = baseResp.code;
    //业务层判断
    if (code == Code.SUCCESS) {
      dynamic data = baseResp.data;
      if (baseResp.hash ?? false) {
        var decryptData = aesDecryptEx(data, Config.encryptKey);
        // print("decryptData:$decryptData");
        data = json.decode(decryptData);
        // data = compute<String, dynamic>(aesAndJsonDecode, data as String);
      }
      baseResp.data = data;
    } else if (code == Code.FORCE_UPDATE_VERSION) {
      //需要更新
      baseResp.msg = "您的版本需要更新了";
      await handleVer(baseResp.data);
    } else if (code == Code.ACCOUNT_INVISIBLE) {
      //账户被封禁了
      baseResp.msg = "您的账号已被封禁了";
      dynamic data = baseResp.data;
      if (baseResp.hash ?? false) {
        var decryptData = aesDecryptEx(data, Config.encryptKey);
        data = json.decode(decryptData);
        // data = compute<String, dynamic>(aesAndJsonDecode, data as String);
      }
      // netManager.setToken("");
      baseResp.data = data;
      DialogGlobal.instance.openAccountBan(
          tip: baseResp.data['reason'], uid: baseResp.data['uid']);
    } else if (code == Code.TOKEN_ABNORMAL) {
      //token异常
      baseResp.msg = "token异常";
      if (!VariableConfig.onMobileLoginView) {
        DialogGlobal.instance.openTakenAbnormalDialog();
      }
    } else if (code == Code.VERIFY_CODE_REPEAT) {
      //验证码频繁异常
      baseResp.msg = "获取验证码过于频繁";
    } else {
      // unknow code
      baseResp.data = null;
    }

    /// 展示提示
    if (code != Code.SUCCESS) {
      if (TextUtil.isEmpty(baseResp.tip)) baseResp.tip = "服务器错误";
      if(code == 7017 || code == 7016 || code == 7019){

      }else {
        showToast(msg: "${baseResp.tip}");
      }

      if(response.request.path == "/product/buy"){
          if(baseResp.tip == "余额不足"){
              bus.emit(EventBusUtils.avCommentaryInsufficientBalance);
          }
      }

    } else {
      if (TextUtil.isNotEmpty(baseResp.tip)) {
        showToast(msg: baseResp.tip);
      }
    }
    debugLog("解密数据:${response.request.path}=>${baseResp.data}");
    if (code != Code.SUCCESS) {
      return Future.error(ApiException(code, baseResp.tip));
    } else {
      return Future.value(baseResp.data);
    }
  }
}

dynamic aesAndJsonDecode(String cipherText) {
  if (TextUtil.isEmpty(cipherText)) return "";
  Uint8List bytes = base64Decode(cipherText);
  String keyTail = String.fromCharCodes(bytes, bytes.length - 6);
  final key = Key.fromUtf8(Config.encryptKey + keyTail);
  final iv = IV.fromUtf8(Config.encryptKey + keyTail);
  Uint8List dst = bytes.sublist(0, bytes.length - 6);
  final encrypt = Encrypter(AES(key, mode: AESMode.cbc));
  final decrypted = encrypt.decryptBytes(Encrypted(dst), iv: iv);
  String decryptData = _utf8decoder.convert(decrypted);
  return json.decode(decryptData);
}

Utf8Decoder _utf8decoder = Utf8Decoder();

///aes解密
String decrypt(String cipherText) {
  if (TextUtil.isEmpty(cipherText)) return "";
  Uint8List bytes = base64Decode(cipherText);
  String keyTail = String.fromCharCodes(bytes, bytes.length - 6);
  final key = Key.fromUtf8(Config.encryptKey + keyTail);
  final iv = IV.fromUtf8(Config.encryptKey + keyTail);
  Uint8List dst = bytes.sublist(0, bytes.length - 6);
  final encrypt = Encrypter(AES(key, mode: AESMode.cbc));
  final decrypted = encrypt.decryptBytes(Encrypted(dst), iv: iv);
  return _utf8decoder.convert(decrypted);
}

/// 新版本解密
String aesDecryptEx(String cipher, String key) {
  // final t1 = DateTime.now();
  final nonceLen = 12;
  final cipherBytes = base64Decode(cipher);
  final nonce = cipherBytes.sublist(0, nonceLen);
  final largeShaRaw = List<int>()..addAll(utf8.encode(key))..addAll(nonce);
  final largeShaRawMid = largeShaRaw.length ~/ 2;
  final msgKeyLarge = sha256.convert(largeShaRaw).bytes;
  final msgKey = msgKeyLarge.sublist(8, 24);

  final shaRawA = List<int>()
    ..addAll(msgKey)
    ..addAll(largeShaRaw.sublist(0, largeShaRawMid));
  final sha256a = sha256.convert(shaRawA).bytes;

  final shaRawB = List<int>()
    ..addAll(largeShaRaw.sublist(largeShaRawMid))
    ..addAll(msgKey);
  final sha256b = sha256.convert(shaRawB).bytes;

  final aesKey = List<int>()
    ..addAll(sha256a.sublist(0, 8))
    ..addAll(sha256b.sublist(8, 24))
    ..addAll(sha256a.sublist(24));

  final aesIV = List<int>()
    ..addAll(sha256b.sublist(0, 4))
    ..addAll(sha256a.sublist(12, 20))
    ..addAll(sha256b.sublist(28));

  final encrypter =
      Encrypter(AES(Key(Uint8List.fromList(aesKey)), mode: AESMode.cbc));
  final decrypted = encrypter.decryptBytes(
      Encrypted(cipherBytes.sublist(nonceLen)),
      iv: IV(Uint8List.fromList(aesIV)));
  // print(decrypted);
  final text = Utf8Decoder().convert(decrypted);
  // final t2 = DateTime.now();
  // print(text);
  // print("deencrypt cost time==========>:${t2.difference(t1).inMilliseconds}ms");
  return text;
}
