import 'package:dio/dio.dart';
import 'package:flutter_base/utils/log.dart';

/// Log 拦截器
class LogsInterceptors extends InterceptorsWrapper {
  static const String TAG = "http_log";
  LogsInterceptors();

  @override
  onRequest(RequestOptions options) {
    l.d(TAG, '################# BEGIN REQUEST #####################\n',
        saveFile: true);
    l.d(TAG, 'method:${options.method}  path:${options.uri.toString()}\n',
        saveFile: true);
    if (options.method == "POST") {
      l.d(TAG,
          'bodyParam:${options?.data?.toString()} extra:${options?.extra?.toString()}\n',
          saveFile: true);
    } else if (options.method == "GET") {
      l.d(TAG,
          'queryParam:${options?.queryParameters?.toString()} extra:${options?.extra?.toString()}\n',
          saveFile: true);
    }
    l.d(TAG, 'header:${options?.headers?.toString()}\n', saveFile: true);
    l.d(TAG, '################# END REQUEST #####################\n',
        saveFile: true);

    return Future.value(options);
  }

  @override
  onResponse(Response response) {
    l.d(TAG, '################# BEGIN RESPONSE #####################\n',
        saveFile: true);
    l.d(TAG, 'path:${response?.request?.uri}\n', saveFile: true);
    l.d(TAG, 'begin code:${response.statusCode}  resp: ${response?.toString()}\n', saveFile: true);
    l.d(TAG, '################# END RESPONSE #####################\n',
        saveFile: true);
    return Future.value(response); // continue
  }

  @override
  onError(DioError err) async {
    l.e(TAG,
        'net onError()...path:${err?.request?.path} err:${err?.toString()}',
        saveFile: true);
    return Future.value(err);
  }
}
