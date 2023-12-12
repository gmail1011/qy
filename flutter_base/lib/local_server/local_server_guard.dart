import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/utils/log.dart';
import 'local_server.dart';

/// 缓存服务的守护程序，主要是一个timer定时器不断重启；
class LocalServerGuard {
  final CacheServer cacheServer;
  final _dio = DioCli();
  bool _running = false;
  bool _checking = false;

  LocalServerGuard(this.cacheServer) : assert(cacheServer != null);

  /// 运行localserver守护
  Future run() async {
    if (_running) return Future.value();
    _running = true;
    await cacheServer.start();
    Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      if (_checking) {
        csPrint("local_server_gard is _checking,please wait...");
        return;
      }
      try {
        _checking = true;
        // csPrint("local_server_gard is called");
        Uri uri = cacheServer.localServerUri;
        if (uri != null) {
          uri = uri.replace(path: LOCAL_SERVER_PING_PATH);
          var options = Options(responseType: ResponseType.bytes);
          // l.i(local_server_tag, "begin ping local server");
          final response =
              await _dio.getBytes(uri.toString(), options: options);
          // l.i(local_server_tag, "end ping local server");
          if ((response?.data?.statusCode ?? 0) > 0) return;
        }
        await cacheServer.start();
      } catch (e) {
        l.e(local_server_tag, "CacheServerGuard()...error:$e");
      } finally {
        _checking = false;
      }
    });
  }
}
