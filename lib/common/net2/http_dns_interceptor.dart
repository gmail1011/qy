import 'package:dio/dio.dart';
import 'package:flutter_base/utils/text_util.dart';

/// 请求dns 拦截器
class HttpHeaderInterceptor extends InterceptorsWrapper {
  final String host;
  HttpHeaderInterceptor(this.host);

  @override
  onRequest(RequestOptions options) async {
    if (TextUtil.isNotEmpty(host)) {
      options.headers["Host"] = host;
    }

    return Future.value(options);
  }

  // @override
  // onResponse(Response response) {
  //   var token = response.headers.map['refresh-authorization']?.last;
  //   if (token != null) {
  //     setToken(token);
  //   }
  //   return Future.value(response);
  // }
}
