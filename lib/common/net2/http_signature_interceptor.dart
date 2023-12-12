import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import 'net_manager.dart';

/// 验签拦截器，主要是做接口安全，加时间戳，加盐，加crc
class SignatureInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    Uri baseUri = Uri.tryParse(options.baseUrl);
    Uri targetUri = Uri(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.port,
        path: baseUri.path + options.path);
    options.headers["x-api-key"] = await sign(targetUri.path);
    return Future.value(options);
  }

  ///生成签名
  static Future<String> sign(String path) async {
    Map<String, dynamic> signObj = {};
    // int timestamp = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    int timestamp =
        netManager.getFixedCurTime().toUtc().millisecondsSinceEpoch ~/ 1000;

    signObj['nonce'] = Uuid().v4();
    // signObj['nonce'] = "779c0b48-71c8-4eb3-bdf7-8de39e64b24b";

    signObj['path'] = path;
    signObj['timestamp'] = timestamp.toString();
    signObj['token'] = await netManager.getToken();
    signObj['userAgent'] = await netManager.userAgent();
    var key = utf8.encode(Config.ANTI_REPLAY_ATTACK_KEY);
    var bytes = utf8.encode(jsonEncode(signObj).toString());
    var sha1Encrypt = new Hmac(sha1, key);
    var digest = sha1Encrypt.convert(bytes);
    return Future.value(
        'timestamp=$timestamp;sign=${digest.toString()};nonce=${signObj['nonce']}');
  }

  /// 随机种子
  // static Random random = Random(DateTime.now().microsecondsSinceEpoch);

  // ///生成随机数
  // static String getRandom(int numSize) {
  //   String alphabet =
  //       'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  //   String result = '';
  //   for (var i = 0; i < numSize; i++) {
  //     result = result + alphabet[random.nextInt(alphabet.length)];
  //   }
  //   return result;
  // }
}
