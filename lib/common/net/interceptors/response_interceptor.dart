import 'dart:convert' as convert;
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/net2/http_resp_interceptor.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/base_response.dart';
import 'package:flutter_app/utils/dailog_global.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import '../code.dart';

/// 网络结果拦截器
class ResponseInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    return super.onRequest(options);
  }

  @override
  onResponse(Response response) async {
    BaseResponse baseResponse;
    if (null == response || response.data == null) {
      baseResponse = BaseResponse(Code.PARSE_DATE_ERROR, "没有返回内容", null);
      l.e("http_log", "response no response!", saveFile: true);
      return Future.value(baseResponse);
    }

    Map<String, dynamic> map;
    if (response.data is Map) {
      map = response.data;
    } else if (response.data is String) {
      map = json.decode(response.data);
    } else {
      baseResponse = BaseResponse(Code.PARSE_DATE_ERROR, "数据返回异常", null);
      l.e("http_log", "response.data is not map", saveFile: true);
      return Future.value((baseResponse));
    }

    try {
      if (map.containsKey("code")) {
        netManager.setServerTime(map['time']);
        dynamic code = map["code"];
        //业务层判断
        if (code == Code.SUCCESS) {
          if (map['hash'] ?? false) {
             var decryptData = aesDecryptEx(map['data'], Config.encryptKey);
            map['data'] = convert.jsonDecode(decryptData);
          }
          baseResponse = BaseResponse(map["code"], map["msg"], map['data']);
        } else if (code == Code.FORCE_UPDATE_VERSION) {
          //需要更新
          baseResponse = BaseResponse(code, "您的版本需要更新了", map["data"]);
          await handleVer(map);
        } else if (code == Code.ACCOUNT_INVISIBLE) {
          //账户被封禁了
          if (map['hash'] ?? false) {
            var decryptData = aesDecryptEx(map['data'], Config.encryptKey);
            map['data'] = convert.jsonDecode(decryptData);
          }
          baseResponse = BaseResponse(code, "您的账号已被封禁了", map["data"]);
          DialogGlobal.instance.openAccountBan(tip: baseResponse.data['reason'],uid:baseResponse.data['uid']);
        } else if (code == Code.TOKEN_ABNORMAL) {
          //token异常
          baseResponse = BaseResponse(code, "token异常", map["data"]);
          if (!VariableConfig.onMobileLoginView) {
            DialogGlobal.instance.openTakenAbnormalDialog();
          }
        } else if (code == Code.VERIFY_CODE_REPEAT) {
          //验证码频繁异常
          baseResponse = BaseResponse(code, "获取验证码过于频繁", map["data"]);
        } else {
          String msg;
          if (map.containsKey("tip") &&
              map["tip"] != null &&
              map["tip"].toString().isNotEmpty) {
            msg = "${map['code']}:${map['tip']}";
          } else {
            if (map.containsKey('msg') &&
                map['msg'] != null &&
                map['msg'].toString().isNotEmpty) {
              msg = "${map['code']}:${map['msg']}";
            } else {
              msg = "${map['code']}:${Lang.SERVER_ERROR}";
            }
          }
          baseResponse = BaseResponse(code, msg, map["data"]);
        }
      }
    } catch (e) {
      l.e("http_log", "onResp:$e", saveFile: true);
      baseResponse = BaseResponse(Code.NETWORK_ERROR, "数据处理异常了", null);
    }
    return Future.value(baseResponse);
  }
}

///存储更新信息
handleVer(Map<String, dynamic> map) async {
  List<dynamic> list = [];
  list.add(map["data"]);
  lightKV.setString(Config.UPDATE_INFO, convert.jsonEncode(list));
  DialogGlobal.instance.openUpdateVersionDialog();
}
