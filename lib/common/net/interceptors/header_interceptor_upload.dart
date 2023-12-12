import 'package:dio/dio.dart';

/// header拦截器
class UploadHeaderInterceptors extends InterceptorsWrapper {
  static const CONTENT_TYPE_JSON = "*/*";

  @override
  onRequest(RequestOptions options) {
    ///超时
    options.connectTimeout = 15000;

    ///接收超时
    options.receiveTimeout = 15000;

    ///发送超时
    options.sendTimeout = 10000;

    ///类型定义
    if (!options.headers.containsKey(Headers.contentTypeHeader)) {
      options.contentType = '*/*';
    }
    return Future.value(options);
  }
}
