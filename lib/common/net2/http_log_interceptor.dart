import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' as Modes;
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/page/game_page/bean/transfer_result_entity.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:r_logger/r_logger.dart';

/// 网络日志拦截器
class HttpLogInterceptor extends InterceptorsWrapper {
  static const String TAG = "http_log";
  HttpLogInterceptor();

  @override
  onRequest(RequestOptions options) {
    if (Modes.kDebugMode) {
      l.d(TAG, '################# BEGIN REQUEST #####################\n',
          saveFile: false);
      l.d(TAG,
          'method:${options.method}  path:${options?.path?.toString()} url:${options?.uri?.toString()}\n',
          saveFile: false);

      if (options?.path?.toString() == "/product/buy") {
        Config.isAbleClickProductBuy = false;
        l.d(
            TAG,
            "Config.isAbleClickProductBuy--------" +
                Config.isAbleClickProductBuy.toString());
      }

      if (options.method == "POST") {
        l.d(TAG,
            'bodyParam:${options?.data?.toString()} extra:${options?.extra?.toString()}\n',
            saveFile: false);
      } else if (options.method == "GET") {
        l.d(TAG,
            'queryParam:${options?.queryParameters?.toString()} extra:${options?.extra?.toString()}\n',
            saveFile: false);
      }
      l.d(TAG, 'header:${options?.headers?.toString()}\n', saveFile: false);
      l.d(TAG, '################# END REQUEST #####################\n',
          saveFile: false);
    }
    return Future.value(options);
  }

  @override
  onResponse(Response response) {
    if (Modes.kDebugMode) {
      l.d(TAG, '################# BEGIN RESPONSE #####################\n',
          saveFile: false);
      l.d(TAG,
          'url:${response?.request?.uri}  path:${response?.request?.path}\n',
          saveFile: false);
      if (!FlutterBase.isRelease)
        l.d(TAG, 'begin resp: ${response?.toString()}\n', saveFile: false);
    }

    if (response?.request?.path.toString() == "/product/buy") {
      Config.isAbleClickProductBuy = true;
      l.d(
          TAG,
          "Config.isAbleClickProductBuy--------" +
              Config.isAbleClickProductBuy.toString());
    }

    if (Config.SHOWLOG) {
      RLogger.instance.j(response?.toString());
    }
    if (response?.request?.path == "/game/dongfang/transfer") {
      if (response.request.method == "POST") {
        Config.transferResultEntity = new TransferResultEntity();
        Config.transferResultEntity.code = response.data["code"];
        Config.transferResultEntity.tip = response.data["tip"];
      }
    }

    if (Modes.kDebugMode) {
      l.d(TAG, '################# END RESPONSE #####################\n',
          saveFile: false);
    }

    return Future.value(response); // continue
  }

  // @override
  // onError(DioError err) async {
  //   l.e(TAG,
  //       'logIntercepter()... onError...url:${err?.request?.uri?.toString()}...path:${err?.request?.path} err:${err?.toString()}',
  //       saveFile: true);
  //   return Future.value(err);
  // }

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
}
