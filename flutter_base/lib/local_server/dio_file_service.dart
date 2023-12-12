import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/cancel_token_manager.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:my_flutter_cache_manager/my_flutter_cache_manager.dart';
import 'package:http/http.dart' hide Response;

import 'local_server.dart';

/// dio 文件下载器
class DioFileService extends FileService {
  // String _getCancelTokenKey(String localReqPath) {
  //   if (localReqPath.endsWith(LOCAL_M3U8_FILTER) ||
  //       localReqPath.endsWith(LOCAL_TS_FILTER)) {
  //     return localReqPath;
  //   }
  //   return null;
  // }
  int failedCnt = 0;
  dynamic error;

  /// 真正请求的dio
  final _dio = createDio();
  final _options = Options(
    method: "GET",
    //连接服务器超时时间，单位是毫秒.
    sendTimeout: 5000,
    //响应流上前后两次接受到数据的间隔，单位为毫秒。
    receiveTimeout: 10000,
    //Http请求头.
    headers: {},
    //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
    contentType: ContentType.binary.toString(),
    //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
    responseType: ResponseType.stream,
  );

  //CustomFileRespons({this._httpClient});
  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String> headers = const {}}) async {
    headers['cache-control'] = 'max-age=31104000';
    _options.headers = headers ?? {};
    var name = FileUtil.getName(url);
    var token = CancelTokenManager().createToken(name);
    Response<ResponseBody> resp;
    try {
      csPrint("_getAllBytes()...开始请求:$url");
      resp = await _dio.get<ResponseBody>(url,
          cancelToken: token, options: _options);
    } catch (e) {
      l.e(local_server_tag, "_getAllBytes()...$url  ERROR:$e");
      error = e;
    } finally {
      CancelTokenManager().remove(url);
    }
    // if (Random().nextInt(10) % 7 == 0) {
    //   resp = null;
    // }
    if (null == resp || resp.statusCode != 200) {
      l.e(local_server_tag,
          "_getAllBytes()...$url   resp is empty<<============");
    } else {
      // failedCnt = 0;
      // csPrint("_getAllBytes()...收到响应(${resp.statusCode}):$url");
    }
    // resp?.headers?.forEach((key, value) {
    //   print('远端header ==> header  key:$key value:$value');
    // });
    Map<String, String> respHeaders = {};
    var contentLengthS = "0";
    if (null != resp?.headers) {
      resp?.headers?.forEach((key, _arrayValue) {
        if (ArrayUtil.isNotEmpty(_arrayValue)) {
          respHeaders[key] = _arrayValue[0];
        }
      });
      var array = resp?.headers[Headers.contentLengthHeader];
      if (ArrayUtil.isNotEmpty(array)) {
        contentLengthS = array[0];
      }
    } else {
      l.e(local_server_tag, "resp header is null");
    }

    int contentLength = int.parse(
        TextUtil.isNotEmpty(contentLengthS[0]) ? contentLengthS : "0");

    csPrint(
        "_getAllBytes()...收到响应(${resp?.statusCode}):$url contentLength:$contentLength");

    Stream<Uint8List> str =
        resp?.data?.stream ?? StreamController<Uint8List>().stream;

    StreamedResponse streamedResponse = StreamedResponse(
        str, resp?.statusCode ?? HttpStatus.badRequest,
        headers: respHeaders, contentLength: contentLength);
    return HttpGetResponse(streamedResponse);
  }
}
