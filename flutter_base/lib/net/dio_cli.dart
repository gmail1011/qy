import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/text_util.dart';

import 'e_data.dart';
import 'isolate_adapter_repo.dart';

final _defaultOptions = BaseOptions(
  connectTimeout: 15000,
  receiveTimeout: 15000,
  // dio 原生会加上 request header:accept-encoding gzip，导致部分请求失败
  // headers: {HttpHeaders.acceptEncodingHeader: "*"},
  validateStatus: (int status) => status < 600,
);

/// 创建一个支持http/http2和兼容tls证书错误的dio层
/// cur => http not http2后台暂时不支持
/// [mainThread] 默认httpclient在主线程中
Dio createDio({BaseOptions options, bool mainThread = true}) {
  if (null == options) options = _defaultOptions;
  options.headers[HttpHeaders.acceptEncodingHeader] = "*";
  var dio = Dio(options);

  var adapter = mainThread ? DefaultHttpClientAdapter() : IsolateAdapterRepo();
  // var adapter = DefaultHttpClientAdapter();
  if (adapter is DefaultHttpClientAdapter) {
    adapter.onHttpClientCreate = (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }

  // var adapter = Http2Adapter(
  //   ConnectionManager(
  //       // 常链接闲的时候保持时间
  //       idleTimeout: 10000,
  //       // Ignore bad certificate
  //       // 兼容证书错误
  //       onClientCreate: (_, clientSetting) {
  //         clientSetting.onBadCertificate = (_) => true;
  //       }),
  // );

  dio.httpClientAdapter = adapter;

  if (FlutterBase.proxyEnable &&
      TextUtil.isNotEmpty(FlutterBase.proxyUrl) &&
      dio.httpClientAdapter is DefaultHttpClientAdapter) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        return FlutterBase.proxyUrl;
      };
    };
  }
  return dio;
}

/// 获取一个请求的rangeStart
/// range bytes=677636-
int getRangeStart(Map<String, String> reqHeaders) {
  var rangeStart = 0;
  if (null != reqHeaders && reqHeaders.containsKey(HttpHeaders.rangeHeader)) {
    // HttpHeaders.contentRangeHeader
    // HttpHeaders
    var rangeStr = reqHeaders[HttpHeaders.rangeHeader];
    if (TextUtil.isNotEmpty(rangeStr)) {
      var arr = rangeStr.split("=");
      if (ArrayUtil.isNotEmpty(arr) && arr.length > 1) {
        var arr2 = arr[1].split("-");
        if (ArrayUtil.isNotEmpty(arr2)) {
          rangeStart = int.parse(arr2[0]);
        }
      }
    }
  }
  return rangeStart;
}

///[address]-代理地址
///"PROXY 192.168.1.150:8888"
// setDioProxy(Dio dio, String address) {
//   if (null == dio || TextUtil.isEmpty(address)) return;
//   if (dio.httpClientAdapter is Http2Adapter) {
//     // (dio.httpClientAdapter as Http2Adapter).
//     //     (client) {
//     //   client.findProxy = (uri) => address;
//     // };
//   } else if (dio.httpClientAdapter is DefaultHttpClientAdapter) {
//     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//         (client) {
//       client.findProxy = (uri) => address;
//     };
//   }
// }

/// dio 帮助类
class DioCli {
  // final BaseOptions options;
  Dio _dio;
  DioCli({BaseOptions options}) {
    _dio = createDio(options: options);
  }

  /// 获取文本
  Future<EData<Response<String>>> getStr(String url,
      {Options options,
      Map<String, dynamic> headers,
      CancelToken cancelToken}) {
    final opt = options ?? Options();
    opt.responseType = ResponseType.plain;
    opt.headers = headers ?? {};
    return asyncCall(
        () => _dio.get<String>(url, options: opt, cancelToken: cancelToken));
  }

  // 获取二进制数据
  Future<EData<Response<List<int>>>> getBytes(String url,
      {Options options,
      Map<String, dynamic> headers,
      CancelToken cancelToken}) {
    final opt = options ?? Options();
    opt.responseType = ResponseType.bytes;
    opt.headers = headers ?? {};
    return asyncCall(
        () => _dio.get<List<int>>(url, options: opt, cancelToken: cancelToken));
  }

  /// 获取数据流
  Future<EData<Response<ResponseBody>>> getStream(String url,
      {Options options,
      Map<String, dynamic> headers,
      CancelToken cancelToken}) {
    final opt = options ?? Options();
    opt.responseType = ResponseType.stream;
    opt.headers = headers ?? {};
    return asyncCall(() =>
        _dio.get<ResponseBody>(url, options: opt, cancelToken: cancelToken));
  }

  /// 获取json数据
  Future<EData<Response<Map<String, dynamic>>>> getJSON(String url,
      {Options options,
      Map<String, dynamic> headers,
      CancelToken cancelToken}) {
    final opt = options ?? Options();
    opt.responseType = ResponseType.json;
    opt.headers = headers ?? {};
    return asyncCall(() => _dio.get<Map<String, dynamic>>(url,
        options: opt, cancelToken: cancelToken));
  }

  /// 获取头
  Future<EData<Response>> getHeader(String url,
      {Options options,
      Map<String, dynamic> headers,
      CancelToken cancelToken}) {
    final opt = options ?? Options();
    opt.responseType = ResponseType.bytes;
    opt.headers = headers ?? {};
    return asyncCall(
        () => _dio.head(url, options: opt, cancelToken: cancelToken));
  }
}
