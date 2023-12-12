import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/CustomHttpClientAdapter.dart';
import 'package:flutter_app/common/net2/base_resp_bean.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/widget/dialog/retry_ping_dialog.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/text_util.dart';

import 'package:flutter_base/utils/light_model.dart';
import 'package:retrofit/dio.dart';

/// 选线工具第三版本,约会和vpn基本统一
/// 主要修改pingcheck的地址
class DetectLineManager {
  Dio _dio = createDio();

  // 取消列表
  var _cancelList = <CancelToken>[];

  /// 一直选线路
  Future<String> detectLineAlways(BuildContext context) async {
    while (true) {
      var line = await _detectLineOnce();

      if (TextUtil.isNotEmpty(line)) {
        _cancelList.forEach((it) => it.cancel());
        _cancelList.clear();
        return line;
      }

      ///完全失败了，弹出对话框
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return RetryPingDialog();
          });
    }
  }

  Future<String> detectLineOnce() async {
    var line = await _detectLineOnce();
    if (TextUtil.isNotEmpty(line)) {
      _cancelList.forEach((it) => it.cancel());
      _cancelList.clear();
      return line;
    }
    return line;
  }

  /// 一次完整的批量选线过程
  Future<String> _detectLineOnce() async {
    ///线路组装
    List<String> lines = [];
    // if (Platform.isIOS && !Config.DEBUG) {
    //   lines.addAll(Config.IOS_LINE_LIST);
    // } else {
    lines.addAll(Config.LINE_LIST);
    // }

    String fileLinesS =
        Config.DEBUG ? '' : await lightKV.getString(Config.KEY_SERVER_DOMAIN);
    if (TextUtil.isNotEmpty(fileLinesS)) {
      List<String> fileLines = json.decode(fileLinesS)?.cast<String>();
      if (ArrayUtil.isNotEmpty(fileLines)) {
        fileLines.forEach((fileLine) {
          if (!lines.contains(fileLine)) {
            lines.add(fileLine);
          }
        });
      }
    }
    String successLine = await _pingCheckPatch(lines);
    // //备用线路失败，使用github的
    // lines.clear();
    // if (TextUtil.isEmpty(successLine)) {
    //   final ret = await DioCli().getPlain(Address.GITHUB_PATH);
    //   if (ret.err == null && ret.data.statusCode == HttpStatus.ok) {
    //     List<dynamic> gitList = json.decode(ret.data.data)["domain"];
    //     gitList.forEach((value) {
    //       if (value is String) {
    //         lines.add(value);
    //       }
    //     });
    //     successLine = await _pingCheckPatch(lines);
    //   }
    // }

    return successLine;
  }

  ///检查一批线路
  Future<String> _pingCheckPatch(List<String> lines) async {
    if (ArrayUtil.isEmpty(lines)) return "";
    //开启一连串异步任务
    Completer<String> completer = Completer();
    var listFuture = <Future<bool>>[];
    List<String> pingOKList = [];
    for (String line in lines) {
      if (TextUtil.isNotEmpty(line))
        listFuture.add((String s) async {
          l.i("selectLine", "_selectLineOnce()...开始选线:$s", saveFile: true);
          var cancelToken = CancelToken();
          _cancelList.add(cancelToken);
          bool suc = await _pingCheck(s);
          _cancelList.remove(cancelToken);
          if (suc ?? false) {
            if (completer.isCompleted) {
              pingOKList.add(s);
            } else {
              l.i("selectLine", "_selectLineOnce()...选线成功:$s", saveFile: true);
              completer.complete(s);
            }
          } else {
            l.e("selectLine", "_selectLineOnce()...线路不可用:$s", saveFile: true);
          }
          return suc ?? false;
        }(line));
    }
    Future.wait<bool>(listFuture).whenComplete(() {
      if (completer.isCompleted) {
        l.i("selectLine", "_selectLineOnce()...is already success}",
            saveFile: true);
        return;
      }
      if (pingOKList.length > 0) {
        l.i("selectLine", "_selectLineOnce()...选线成功:${pingOKList[0]}",
            saveFile: true);
        completer.complete(pingOKList[0]);
      } else {
        l.i("selectLine", "_selectLineOnce()...not avalible line}",
            saveFile: true);
        completer.complete(null);
      }
    }); // 异步
    return completer.future;
  }

  /// 单次网络请求
  Future<bool>   _pingCheck(String line, [CancelToken cancelToken]) async {
    Response resp;
    DateTime startTime = DateTime.now();

    try {
      // String path = "/api/pingCheck";
      String path = "/api/app/ping/check";
      String method = "GET";
      // netManager.setDioProxy(_dio);
      if (Config.DNS_CUSTOM && TextUtil.isNotEmpty(Config.DNS_IP)) {
        _dio.httpClientAdapter = CustomHttpClientAdapter(Config.DNS_IP);
      }
      var reqUrl = line + path;

      l.i("_pingCheck", "reqUrl:$reqUrl", saveFile: true);
      resp = await _dio.request(reqUrl,
          options: RequestOptions(
              method: method,
              connectTimeout: 50 * 1000,
              receiveTimeout: 50 * 1000,
              headers: {
                // "token": await netManager.getToken(),
                // "User-Agent": await netManager.userAgent(),
                // "x-api-key": await netManager.sign(path, method, {}),
              },
              cancelToken: cancelToken));
    } catch (e) {
      l.e("ping", "pingCheck()...error:$e");
    }
    l.i("ping",
        "pingCheck()...line:$line cost ${DateTime.now().difference(startTime).inMilliseconds} milSeconds");
    if (null == resp || resp.statusCode != HttpStatus.ok) {
      l.e("ping", "pingCheck()...resp is null or code:${resp?.statusCode}");
      return false;
    }
    BaseRespBean baseResp;
    if (resp.data is Map) {
      baseResp = BaseRespBean.fromJson(resp.data);
    } else if (resp.data is String) {
      baseResp = BaseRespBean.fromJson(json.decode(resp.data));
    }
    if (TextUtil.isNotEmpty(baseResp?.time)) {
      // print("==================>setServer Time:$serverTime");
      netManager.setServerTime(baseResp.time);
    }
    // 业务码200才算成功
    return baseResp?.code == HttpStatus.ok;
  }

  /// 单次网络请求
  Future<String> getDnsAddress(String path, [CancelToken cancelToken]) async {
    Response resp;
    Dio _dio = createDio(); //获取DNS，用单独的网络请求
    try {
      resp = await _dio.request(
        path,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            baseUrl: path,
            responseType: ResponseType.plain,
            receiveTimeout: 5000,
            connectTimeout: 5000),
      );
    } catch (e) {
      l.e("ping", "pingCheck()...error:$e");
    }
    l.e("resp", "resp..error:${resp.toString()}");
    if (null == resp || resp.statusCode != HttpStatus.ok) {
      l.e("ping", "pingCheck()...resp is null or code:${resp?.statusCode}");
      return "";
    }
    BaseRespBean baseResp;
    if (resp.data is Map) {
      baseResp = BaseRespBean.fromJson(resp.data);
    } else if (resp.data is String) {
      baseResp = BaseRespBean.fromJson(json.decode(resp.data));
    }
    return baseResp?.data;
  }
}
