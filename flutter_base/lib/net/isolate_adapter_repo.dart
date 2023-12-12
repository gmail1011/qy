import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:my_worker_manager/my_worker_manager.dart';
import 'my_default_http_adapter.dart';

class _RequestOptions {
  _RequestOptions({
    this.method,
    this.sendTimeout,
    this.receiveTimeout,
    this.connectTimeout,
    this.data,
    this.path,
    this.queryParameters,
    this.baseUrl,
    // this.onReceiveProgress,
    // this.onSendProgress,
    // this.cancelToken,
    this.extra,
    this.headers,
    this.responseType,
    this.contentType,
    // this.validateStatus,
    this.receiveDataWhenStatusError = true,
    this.followRedirects = true,
    this.maxRedirects,
    // this.requestEncoder,
    // this.responseDecoder,
  });

  /// Request data, can be any type.
  dynamic data;

  /// Request base url, it can contain sub path, like: 'https://www.google.com/api/'.
  String baseUrl;

  /// If the `path` starts with 'http(s)', the `baseURL` will be ignored, otherwise,
  /// it will be combined and then resolved with the baseUrl.
  String path = '';

  /// See [Uri.queryParameters]
  Map<String, dynamic> queryParameters;

  // CancelToken cancelToken;

  // ProgressCallback onReceiveProgress;

  // ProgressCallback onSendProgress;

  int connectTimeout;

  /// Http method.
  String method;

  /// Http request headers. The keys of initial headers will be converted to lowercase,
  /// for example 'Content-Type' will be converted to 'content-type'.
  ///
  /// You should use lowercase as the key name when you need to set the request header.
  Map<String, dynamic> headers;

  /// Timeout in milliseconds for sending data.
  /// [Dio] will throw the [DioError] with [DioErrorType.SEND_TIMEOUT] type
  ///  when time out.
  int sendTimeout;

  ///  Timeout in milliseconds for receiving data.
  ///  [Dio] will throw the [DioError] with [DioErrorType.RECEIVE_TIMEOUT] type
  ///  when time out.
  ///
  /// [0] meanings no timeout limit.
  int receiveTimeout;

  /// The request Content-Type. The default value is [ContentType.json].
  /// If you want to encode request body with 'application/x-www-form-urlencoded',
  /// you can set `ContentType.parse('application/x-www-form-urlencoded')`, and [Dio]
  /// will automatically encode the request body.
  String contentType;

  /// [responseType] indicates the type of data that the server will respond with
  /// options which defined in [ResponseType] are `json`, `stream`, `plain`.
  ///
  /// The default value is `json`, dio will parse response string to json object automatically
  /// when the content-type of response is 'application/json'.
  ///
  /// If you want to receive response data with binary bytes, for example,
  /// downloading a image, use `stream`.
  ///
  /// If you want to receive the response data with String, use `plain`.
  ///
  /// If you want to receive the response data with  original bytes,
  /// that's to say the type of [Response.data] will be List<int>, use `bytes`
  ResponseType responseType;

  /// `validateStatus` defines whether the request is successful for a given
  /// HTTP response status code. If `validateStatus` returns `true` ,
  /// the request will be perceived as successful; otherwise, considered as failed.
  // ValidateStatus validateStatus;

  /// Whether receiving response data when http status code is not successful.
  bool receiveDataWhenStatusError;

  /// Custom field that you can retrieve it later in [Interceptor]、[Transformer] and the [Response] object.
  Map<String, dynamic> extra;

  /// see [HttpClientRequest.followRedirects]
  bool followRedirects;

  /// Set this property to the maximum number of redirects to follow
  /// when [followRedirects] is `true`. If this number is exceeded
  /// an error event will be added with a [RedirectException].
  ///
  /// The default value is 5.
  int maxRedirects;

  /// The default request encoder is utf8encoder, you can set custom
  /// encoder by this option.
  // RequestEncoder requestEncoder;

  /// The default response decoder is utf8decoder, you can set custom
  /// decoder by this option, it will be used in [Transformer].
  // ResponseDecoder responseDecoder;

  _RequestOptions.fromRequestOptions(RequestOptions options) {
    this.method = options.method;
    this.sendTimeout = options.sendTimeout;
    this.receiveTimeout = options.receiveTimeout;
    this.connectTimeout = options.connectTimeout;
    this.data = options.data;
    this.path = options.path;
    this.queryParameters = options.queryParameters;
    this.baseUrl = options.baseUrl;
    // this.onReceiveProgress = options.onReceiveProgress;
    // this.onSendProgress = options.onSendProgress;
    // this.cancelToken = options.cancelToken;
    this.extra = Map.from(options.extra ?? {});
    this.headers = Map.from(options.headers ?? {});
    this.responseType = options.responseType;
    this.contentType = options.contentType ?? "*/*";
    // this.validateStatus = options.validateStatus;
    this.receiveDataWhenStatusError = options.receiveDataWhenStatusError;
    this.followRedirects = options.followRedirects;
    this.maxRedirects = options.maxRedirects;
    // this.requestEncoder = options.requestEncoder;
    // this.responseDecoder = options.responseDecoder;
  }
}

RequestOptions getRO(_RequestOptions options) {
  return RequestOptions(
    method: options.method,
    sendTimeout: options.sendTimeout,
    receiveTimeout: options.receiveTimeout,
    connectTimeout: options.connectTimeout,
    data: options.data,
    path: options.path,
    queryParameters: options.queryParameters,
    baseUrl: options.baseUrl,
    // onReceiveProgress: options.onReceiveProgress,
    // onSendProgress: options.onSendProgress,
    // cancelToken: options.cancelToken,
    extra: Map.from(options.extra ?? {}),
    headers: Map.from(options.headers ?? {}),
    responseType: options.responseType,
    contentType: options.contentType ?? "*/*",
    // validateStatus: options.validateStatus,
    receiveDataWhenStatusError: options.receiveDataWhenStatusError,
    followRedirects: options.followRedirects,
    maxRedirects: options.maxRedirects,
    // requestEncoder: options.requestEncoder,
    // responseDecoder: options.responseDecoder,
  );
}

MyDefaultHttpClientAdapter myclient = MyDefaultHttpClientAdapter();
Future<SimpleResponseBody> _fetch(_RequestOptions options) async {
  RequestOptions ro = getRO(options);
  return myclient.fetch(ro, null, null);
}

void _close(bool force) {
  return myclient.close(force: force);
}

class IsolateAdapterRepo implements HttpClientAdapter {
  @override
  void close({bool force = false}) {
    // compute(_close, force);
    myclient.close(force: force);
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>> requestStream, Future cancelFuture) async {
    var newOptions = _RequestOptions.fromRequestOptions(options);
    var resp = await Executor().execute(fun1: _fetch, arg1: newOptions);
    // var resp = (await compute(_fetch, newOptions));
    // print("from isolate data:${resp.stream}");

    return ResponseBody(
      Stream.value(Uint8List.fromList(utf8.encode(resp.stream))),
      resp.statusCode,
      headers: resp.headers,
      statusMessage: resp.statusMessage,
      isRedirect: resp.isRedirect,
      redirects: resp.redirects,
    );
  }
}
