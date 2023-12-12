import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:dio/dio.dart';

class SimpleResponseBody {
  SimpleResponseBody(
    this.stream,
    this.statusCode, {
    this.headers,
    this.statusMessage,
    this.isRedirect,
    this.redirects,
  });

  /// The response stream
  // Stream<Uint8List> stream;
  // Stream<List<int>> stream;
  String stream;

  /// the response headers
  Map<String, List<String>> headers;

  /// Http status code
  int statusCode;

  /// Returns the reason phrase associated with the status code.
  /// The reason phrase must be set before the body is written
  /// to. Setting the reason phrase after writing to the body.
  String statusMessage;

  /// Whether this response is a redirect.
  final bool isRedirect;

  List<RedirectRecord> redirects;

  Map<String, dynamic> extra = {};
}

typedef OnHttpClientCreate = dynamic Function(HttpClient client);

/// The default HttpClientAdapter for Dio.
class MyDefaultHttpClientAdapter
// implements HttpClientAdapter
{
  /// [Dio] will create HttpClient when it is needed.
  /// If [onHttpClientCreate] is provided, [Dio] will call
  /// it when a HttpClient created.
  OnHttpClientCreate onHttpClientCreate;

  HttpClient _defaultHttpClient;

  bool _closed = false;

  MyDefaultHttpClientAdapter() {
    this.onHttpClientCreate = (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }

  @override
  Future<SimpleResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>> requestStream,
    Future cancelFuture,
  ) async {
    if (_closed) {
      throw Exception(
          "Can't establish connection after [HttpClientAdapter] closed!");
    }
    var _httpClient = _configHttpClient(cancelFuture, options.connectTimeout);
    Future requestFuture = _httpClient.openUrl(options.method, options.uri);

    void _throwConnectingTimeout() {
      throw DioError(
        request: options,
        error: 'Connecting timed out [${options.connectTimeout}ms]',
        type: DioErrorType.CONNECT_TIMEOUT,
      );
    }

    HttpClientRequest request;
    try {
      request = await requestFuture;
      //Set Headers
      options.headers.forEach((k, v) => request.headers.set(k, v));
    } on SocketException catch (e) {
      if (e.message.contains('timed out')) _throwConnectingTimeout();
      rethrow;
    }

    request.followRedirects = options.followRedirects;
    request.maxRedirects = options.maxRedirects;
    requestStream = await _transformData(options);
    if (options.method != 'GET' && requestStream != null) {
      // Transform the request data
      await request.addStream(requestStream);
    }
    Future future = request.close();
    if (options.connectTimeout > 0) {
      future = future.timeout(Duration(milliseconds: options.connectTimeout));
    }
    HttpClientResponse responseStream;
    try {
      responseStream = await future;
    } on TimeoutException {
      _throwConnectingTimeout();
    }
    String respData =
        await responseStream.transform<String>(utf8.decoder).join();

    // https://github.com/dart-lang/co19/issues/383
    // var stream =
    //     responseStream.transform<Uint8List>(StreamTransformer.fromHandlers(
    //   handleData: (data, sink) {
    //     sink.add(Uint8List.fromList(data));
    //   },
    // ));

    var headers = <String, List<String>>{};
    responseStream.headers.forEach((key, values) {
      headers[key] = values;
    });
    var redirects = responseStream.redirects
        .map((e) => RedirectRecord(e.statusCode, e.method, e.location))
        .toList();
    return SimpleResponseBody(
      respData,
      responseStream.statusCode,
      headers: headers,
      isRedirect:
          responseStream.isRedirect || responseStream.redirects.isNotEmpty,
      redirects: redirects,
      statusMessage: responseStream.reasonPhrase,
    );
  }

  HttpClient _configHttpClient(Future cancelFuture, int connectionTimeout) {
    var _connectionTimeout = connectionTimeout > 0
        ? Duration(milliseconds: connectionTimeout)
        : null;
    if (cancelFuture != null) {
      var _httpClient = HttpClient();
      _httpClient.userAgent = null;
      if (onHttpClientCreate != null) {
        //user can return a HttpClient instance
        _httpClient = onHttpClientCreate(_httpClient) ?? _httpClient;
      }
      _httpClient.idleTimeout = Duration(seconds: 0);
      cancelFuture.whenComplete(() {
        Future.delayed(Duration(seconds: 0)).then((e) {
          try {
            _httpClient.close(force: true);
          } catch (e) {
            //...
          }
        });
      });
      return _httpClient..connectionTimeout = _connectionTimeout;
    } else if (_defaultHttpClient == null) {
      _defaultHttpClient = HttpClient();
      _defaultHttpClient.idleTimeout = Duration(seconds: 3);
      if (onHttpClientCreate != null) {
        //user can return a HttpClient instance
        _defaultHttpClient =
            onHttpClientCreate(_defaultHttpClient) ?? _defaultHttpClient;
      }
      _defaultHttpClient.connectionTimeout = _connectionTimeout;
    }
    return _defaultHttpClient;
  }

  @override
  void close({bool force = false}) {
    _closed = _closed;
    _defaultHttpClient?.close(force: force);
  }
}

Transformer transformer = DefaultTransformer();
Future<Stream<Uint8List>> _transformData(RequestOptions options) async {
  var data = options.data;
  List<int> bytes;
  Stream<List<int>> stream;
  if (data != null &&
      ['POST', 'PUT', 'PATCH', 'DELETE'].contains(options.method)) {
    // Handle the FormData
    int length;
    if (data is Stream) {
      assert(data is Stream<List>,
          'Stream type must be `Stream<List>`, but ${data.runtimeType} is found.');
      stream = data;
      options.headers.keys.any((String key) {
        if (key.toLowerCase() == Headers.contentLengthHeader) {
          length = int.parse(options.headers[key].toString());
          return true;
        }
        return false;
      });
    } else if (data is FormData) {
      if (data is FormData) {
        options.headers[Headers.contentTypeHeader] =
            'multipart/form-data; boundary=${data.boundary}';
      }
      stream = data.finalize();
      length = data.length;
    } else {
      // Call request transformer.
      var _data = await transformer.transformRequest(options);
      if (options.requestEncoder != null) {
        bytes = options.requestEncoder(_data, options);
      } else {
        //Default convert to utf8
        bytes = utf8.encode(_data);
      }
      // support data sending progress
      length = bytes.length;

      var group = <List<int>>[];
      const size = 1024;
      var groupCount = (bytes.length / size).ceil();
      for (var i = 0; i < groupCount; ++i) {
        var start = i * size;
        group.add(bytes.sublist(start, math.min(start + size, bytes.length)));
      }
      stream = Stream.fromIterable(group);
    }

    if (length != null) {
      options.headers[Headers.contentLengthHeader] = length.toString();
    }
    var complete = 0;
    var byteStream = stream.transform<Uint8List>(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        if (options.cancelToken != null && options.cancelToken.isCancelled) {
          sink
            ..addError(options.cancelToken.cancelError)
            ..close();
        } else {
          sink.add(Uint8List.fromList(data));
          if (length != null) {
            complete += data.length;
            if (options.onSendProgress != null) {
              options.onSendProgress(complete, length);
            }
          }
        }
      },
    ));
    if (options.sendTimeout > 0) {
      byteStream.timeout(Duration(milliseconds: options.sendTimeout),
          onTimeout: (sink) {
        sink.addError(DioError(
          request: options,
          error: 'Sending timeout[${options.connectTimeout}ms]',
          type: DioErrorType.SEND_TIMEOUT,
        ));
        sink.close();
      });
    }
    return byteStream;
  } else {
    options.headers.remove(Headers.contentTypeHeader);
  }
  return null;
}
