import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart' as Configs;
import 'package:flutter_app/common/image/decrypt_image.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';

class ImageCacheManager extends CacheManager {
  static const image_key = "customCache";

  static ImageCacheManager _instance;

  factory ImageCacheManager() {
    if (_instance == null) {
      _instance = new ImageCacheManager._();
    }
    return _instance;
  }

  ImageCacheManager._()
      : super(Config(image_key,
            maxNrOfCacheObjects: 3000,
            stalePeriod: Duration(days: 7),
            fileService: CustomFileRespons()));

  // ImageCacheManager._()
  //     : super(image_key,
  //           maxAgeCacheObject: Duration(days: 7),
  //           maxNrOfCacheObjects: 1024,
  //           fileService: CustomFileRespons());

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, image_key);
  }

//   static Future<FileFetcherResponse> _customHttpGetter(String url,
//       {Map<String, String> headers}) async {
//     if (!url.startsWith("http") && !url.startsWith("https")) {
//       url = path.join(Address.baseImagePath ?? '', url);
//     }
//     Response response = await http.get(url, headers: headers);
//     Response newResponse =
//         Response.bytes(decryptImage(response.bodyBytes), response.statusCode);
//     return HttpFileFetcherResponse(newResponse);
//   }
}

class CustomFileRespons extends HttpFileService {
  // http.Client _httpClient = http.Client();

  //CustomFileRespons({this._httpClient});
  DioCli client = DioCli(
      options: BaseOptions(
    connectTimeout: 15000,
    receiveTimeout: 15000,
    sendTimeout: 15000,
    validateStatus: (int status) => status < 600,
  ));
  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String> headers = const {}}) async {
    if (!url.startsWith("http") && !url.startsWith("https")) {
      url = path.join(Address.baseImagePath ?? '', url);
    }
    // print("image what to get:$url");

    if(kDebugMode){
      l.i("image_request", "get()...begin...ulr:$url...");
    }

    headers['cache-control'] = 'max-age=31104000';
    // var resp = await client.getStream(url, headers: headers);
    var resp = await client.getBytes(url, headers: headers);

    // if (null == resp?.err && null != resp?.data?.data) {
    //   content = resp?.data?.data;
    // }

    Map<String, String> respHeaders = {};
    var contentLengthS = "0";
    if (null != resp?.data?.headers) {
      resp?.data?.headers?.forEach((key, _arrayValue) {
        if (ArrayUtil.isNotEmpty(_arrayValue)) {
          respHeaders[key] = _arrayValue[0];
        }
      });
      var array = resp?.data?.headers["Content-Length"];
      if (ArrayUtil.isNotEmpty(array)) {
        contentLengthS = array[0];
      }
    } else {
      if(kDebugMode){
        l.e("image_request", "resp header is null  $url");
      }
    }

    int contentLength = int.parse(
        TextUtil.isNotEmpty(contentLengthS[0]) ? contentLengthS : "0");
    if (contentLength <= 0) {
      contentLength = resp?.data?.data?.length ?? 0;
    }
    if (null != resp?.err) {
      if(kDebugMode){
        l.e("image_request",
            "get()...failed...$url...code:(${resp?.data?.statusCode}): ${resp?.err}");
      }

    } else {
      if(kDebugMode){
        l.i("image_request",
            "get()...success...$url...code:(${resp?.data?.statusCode}): contentLength:$contentLength");
      }
    }

    StreamedResponse streamedResponse = StreamedResponse(
      Stream.fromFuture(Future.value(decryptImage(resp?.data?.data))),
      resp?.data?.statusCode ?? HttpStatus.badRequest,
      contentLength: contentLength,
      headers: respHeaders,
    );

    // final request = http.Request('GET', Uri.parse(url));
    // request.headers.addAll(headers);
    // final resp = await _httpClient.send(request);
    // var stream = await resp.stream.toBytes();
    // StreamedResponse streamedResponse = StreamedResponse(
    //     Stream.fromFuture(Future.value(decryptImage(stream))),
    //     resp.statusCode,
    //     contentLength: resp.contentLength,
    //     request: resp.request,
    //     headers: resp.headers,
    //     isRedirect: resp.isRedirect,
    //     persistentConnection: resp.persistentConnection,
    //     reasonPhrase: resp.reasonPhrase);

    return HttpGetResponse(streamedResponse);
  }
}
