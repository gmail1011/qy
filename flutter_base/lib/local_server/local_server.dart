import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/cancel_token_manager.dart';
import 'package:flutter_base/local_server/video_cache_manager.dart';
import 'package:flutter_base/local_server/video_sub_cache_manager.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:my_flutter_cache_manager/my_flutter_cache_manager.dart';
import 'package:rxdart/subjects.dart';

const LOCAL_M3U8_FILTER = ".m3u8";
const LOCAL_TS_FILTER = ".ts";
const LOCAL_ALL_FILTER = ".*";
const LOCAL_SERVER_PING_PATH = "/__ping__";

// localserver把这个请求给外部处理的回调
typedef void CustomResponse(HttpRequest response);

const String local_server_tag = "cache-server";

/// 加密魔数头
const encryptMagicNumber = [0x88, 0xA8, 0x30, 0xCB, 0x10, 0x76];

/// 加密密钥
const ENCRYPT_KEY = 0xA3;

/// 是否是加密文件
bool _isEncryptData(List<int> buf) {
  if (ArrayUtil.isEmpty(buf) || buf.length < encryptMagicNumber.length) {
    return false;
  }
  for (int iLoop = 0; iLoop < encryptMagicNumber.length; iLoop++) {
    if (buf[iLoop] != encryptMagicNumber[iLoop]) return false;
  }
  return true;
}

/// 打印控制
csPrint(Object msg) {
  // l.i(local_server_tag, "$msg", saveFile: false);
}

/// headers 的异步构造函数
typedef HeadersBuilder = Future<Map<String, dynamic>> Function(Uri uri);

/// 是否加入二级缓存
typedef JoinSubCache = bool Function(String specialCharacters);

/// 单个请求拦截单元
class ReqFilter {
  /// 要拦截的正则表达,这里是以.m3u8 和 .ts 结尾的请求
  final String reg;

  final String schema; //http, https
  final String host; // www.qiNiu.com
  final int port; // null or 12345
  final String pathPrefix; //m3u8 是api/app/vid/m3u8
  final HeadersBuilder headersBuilder;
  ReqFilter(this.reg, this.schema, this.host,
      {this.port, this.pathPrefix = "", this.headersBuilder})
      : assert(TextUtil.isNotEmpty(reg)),
        assert(TextUtil.isNotEmpty(host));

  String toString() => Uri(scheme: schema, host: host, port: port).toString();
}

/// localServer 第三版 功能
/// 1，删除了以前依赖的flutter_cache_manager和文件锁，加快访问和减少维护成本;
/// 2，增加了网络请求重复的检测;
/// 3，增加了网络下载速度的功能;
/// note-this: 不要随意修改，修改之前先问下我
///
/// localServer 第四版 功能
/// 1，用cacheManager的请求接口盒请求去除重复来代替我们自己的;
/// 2，减少网络请求错误;
/// 3, 修复了一些bug;
/// 4，去掉了以前的下载速度;
/// 另外后期;1，可能把tasklist里面的cancel去掉；2，添加下载速度 okay
/// note-this: 不要随意修改，修改之前先问下我
///
/// localServer 第五版 功能
/// 实时返回响应数据
/// localServer 第六版 功能
/// 支持预缓存isPreCache
///  localServer 第七版 功能
///  兼容色中色的localserver请求
/// localServer 第八版 功能
/// 支持任意文件任意请求异或加密，解密
class CacheServer {
  static CacheServer _instance;
  int serverPort = 14587;
  var _dio = createDio();

  /// ts 流强制经过localserver
  /// 一些ts流带了域名，会直接访问;不经过localserver缓存
  bool forceThroghLocalServer = true;

  /// 当前下载速度
  int _nowVideoSpeed = 0;

  /// 获取当前的下载速度
  int get getVideoSpeed => _nowVideoSpeed;
  // 下载速度控制器
  final BehaviorSubject<int> _speedController = BehaviorSubject<int>();
  // final PublishSubject<int> _speedController = PublishSubject<int>();
  // final StreamController<int> _speedController = StreamController.broadcast();
  // 下载速度的流
  Stream<int> get onVideoSpeedUpdate => _speedController.asBroadcastStream();

  // 失败m3u8 列表
  List<String> failedM3u8List = [];

  /// localServer 闲时回调，应该返回一个remotePath
  AsyncValueGetter<String> onLocalServerIdel;

  HttpServer _server;
  // 主缓存
  BaseCacheManager _cacheManager;
// 二级缓存
  BaseCacheManager _subCacheManager;

  bool _openSubManager = true;

  // 处理加密和解密的的函数
  Map<String, CustomResponse> _customResponse = {};

  /// 启动Competer,避免重复启动
  Completer _startCompleter;

  // 是否允许加入二级缓存
  JoinSubCache onJoinSubCache;
  ValueChanged<dynamic> onErr;

  /// 请求拦截表
  Map<String, ReqFilter> _reqFilterMap = {};

  String selectLine;

  factory CacheServer({
    BaseCacheManager cacheManager,
    bool forceThroghLocalServer = true,
    bool openSubManager = false,
  }) {
    if (_instance == null) {
      if (cacheManager == null) cacheManager = VideoCacheManager();
      _instance = CacheServer._(
        cacheManager,
        forceThroghLocalServer: forceThroghLocalServer,
        openSubManager: openSubManager,
      );
    }
    return _instance;
  }

  void registerErrCallBack(ValueChanged onError) {
    this.onErr = onError;
  }

  String setSelectLine(String line){
    selectLine = line;
    return selectLine;
  }

  CacheServer._(BaseCacheManager cacheManager,
      {bool forceThroghLocalServer = true, bool openSubManager = false})
      : _cacheManager = cacheManager,
        this.forceThroghLocalServer = forceThroghLocalServer,
        this._openSubManager = openSubManager,
        _subCacheManager = VideoSubCacheManager();

  /// 启动服务器
  /// 有错返错，没错返null
  Future start() async {
    if (_startCompleter != null) {
      csPrint("already has a startComplete");
      return _startCompleter.future;
    }

    _startCompleter = Completer();
    csPrint("begin start localserver inner");
    _startInner(); // async
    return _startCompleter.future;
  }

  /// 内部启动
  /// [remoteCdnAndPathPrefix] http://cnd/app/vid/
  _startInner() async {
    // 先关闭原来的，再启动
    await stop(true);
    _server = await _bindAlways();
    csPrint("_startInner()...begin listen:$serverPort");
    _server.listen(_onRequest,
        onDone: _onServerDone, onError: _onServerError, cancelOnError: true);

    csPrint("_bind success, start listen address:$localServerUri");
    _startCompleter.complete();
    _startCompleter = null;
  }

  /// 一直启动绑定localServer只到成功
  Future<HttpServer> _bindAlways() async {
    while (true) {
      try {
        csPrint("_bindAlways()...serverPort:$serverPort");
        return await HttpServer.bind(InternetAddress.loopbackIPv4, serverPort);
      } catch (e) {
        l.e(local_server_tag, "bind fail $serverPort, err $e");
      }
      await Future.delayed(Duration(milliseconds: 200));
      serverPort++;
      continue;
    }
  }

  /// 服务器停止
  /// [force] 强制停止，设置为true将会不等待请求，直接关闭链接
  Future stop([bool force = false]) async {
    if (_server != null) {
      try {
        csPrint("[LOCSERV] 关闭server");
        await _server.close(force: true);
      } catch (e) {
        l.e(local_server_tag, "[LOCSERV] 关闭server失败，可能是因为服务被系统杀掉了");
      }
    }
  }

  /// 请求转发过滤器
  /// 根据文件后缀转发
  /// [reg] 正则表达式fileExtension需要带上. ".m3u8" ".ts"
  void addReqFilter(String reg, String forwardUrl,
      {bool force = false, String pathPrefix = "", HeadersBuilder hb}) {
    assert(reg != null);
    assert(reg.startsWith("."));
    if (TextUtil.isEmpty(forwardUrl)) {
      showToast(msg: "CDN地址为空");
    }
    assert(forwardUrl != null, "地址为空");
    final uri = Uri.tryParse(forwardUrl);
    if (uri == null) {
      l.e(local_server_tag, "addReqFilter()...invalid url: $forwardUrl");
      return;
    }
    // 转发结构体
    final reqFilter = ReqFilter(reg, uri.scheme, uri.host,
        port: uri.port, pathPrefix: pathPrefix, headersBuilder: hb);
    if (force) {
      // 不同的转发域，对应的转发函数
      _reqFilterMap[reg] = reqFilter;
    } else {
      _reqFilterMap.putIfAbsent(reg, () => reqFilter);
    }
  }

  /// 添加外部系统拦截调用，对于localserver一般是ttl
  void addCustomResponse(String path, CustomResponse response,
      {bool force = false}) {
    if (force) {
      _customResponse[path] = response;
    } else {
      _customResponse.putIfAbsent(path, () => response);
    }
  }

  /// 获取localserver的信息
  Uri get localServerUri =>
      Uri(scheme: "http", host: _server?.address?.host, port: _server?.port);

  /// localserver的请求拦截
  void _onRequest(HttpRequest request) {
    switch (request.method) {
      case "GET":
        _handleGet(request);
        break;
      default:
        // ���时只支持GET
        request.response.statusCode = HttpStatus.badRequest;
        request.response.close();
    }
  }

  void _onServerError(err) {
    l.e(local_server_tag, "_onServerError err $err");
  }

  void _onServerDone() {
    csPrint("Server Closed.");
    _server = null;
  }

  ///  拦截请求
  Future _handleGet(HttpRequest localReq) async {
    //这里处理其他层发送过来的ping
    if (localReq.uri.path == LOCAL_SERVER_PING_PATH) {
      localReq.response.statusCode = HttpStatus.ok;
      localReq.response.close();
      return;
    }
    csPrint("Receive ${localReq.method} request ${localReq.uri}");
    // 处理ttl的加密
    final response = _customResponse[localReq.uri.path];
    if (response != null) {
      csPrint("Custom Response ${localReq.uri}");
      response.call(localReq);
      return;
    }

    //存储文件的路径������������也是cache的Key
    String cacheKey = getCacheKey(localReq.uri.path);
    // FileInfo info = await _cacheManager.getFileFromCache(cachePath);

    // //找到缓存，把文件中的数据当响应流返回
    // if (null != info && info.file.existsSync()) {
    //   try {
    //     csPrint("Cache Hit path:$cachePath localUri:${localReq.uri}");
    //     await localReq.response.addStream(info.file.openRead());
    //     localReq.response.close();
    //     return;
    //   } on FileSystemException catch (e) {
    //     l.e(local_server_tag,
    //         "Cache Hit But FileSystemException ${localReq.uri} exception: $e");
    //     await _cacheManager.removeFile(cachePath);
    //     return;
    //   }
    // }

    //非文件的本地请求
    final dot = localReq.uri.path.lastIndexOf(".");
    if (dot < 0) {
      csPrint("_handleGet path no registry ${localReq.uri}");
      localReq.response.statusCode = HttpStatus.badRequest;
      localReq.response.close();
      return;
    }

    // 根据文件扩展名字获取请求过滤
    final fileExtension = localReq.uri.path.substring(dot);
    var reqFilter =
        _reqFilterMap[fileExtension] ?? _reqFilterMap[LOCAL_ALL_FILTER];
    if (reqFilter == null) {
      l.e(local_server_tag,
          "_handleGet path not find ${localReq.uri} reqFilter:$fileExtension");
      localReq.response.statusCode = HttpStatus.badRequest;
      localReq.response.close();
      return;
    }

    // 是否是预缓存的请求
    bool isPreCache = false;
    Map<String, String> queryParameters = {};
    queryParameters.addAll(localReq?.uri?.queryParameters ?? {});
    if (queryParameters.containsKey("isPreCache") ?? false) {
      queryParameters.remove("isPreCache");
      isPreCache = true;
    }

    //构建远程请求和请求的headers
    var remoteUri = localReq.uri.replace(
        scheme: reqFilter.schema,
        host: reqFilter.host,
        port: reqFilter.port,
        queryParameters:
            fileExtension == LOCAL_TS_FILTER ? {} : queryParameters);
    var remoteUriStr = remoteUri.toString();
    if (remoteUriStr.endsWith("?")) {
      remoteUri = Uri.parse(remoteUriStr.replaceAll("?", ""));
    }
    Map<String, String> localReqHeaders = {};
    localReq.headers.forEach((String name, List<String> values) {
      if (name == "host") return;
      if (ArrayUtil.isEmpty(values)) return;
      // 暂时只取第一个
      localReqHeaders[name] = values[0];
      csPrint("request header:$name ${values[0]}");
    });
    if (reqFilter.headersBuilder != null) {
      localReqHeaders.addAll(await reqFilter.headersBuilder.call(remoteUri));
    }
    // localReqHeaders.remove("range");
    csPrint("Cache Miss ${localReq.method} cachePath:$cacheKey => $remoteUri");

    /// 获取远程文件,l里面调用了unawaited streamConroller close,不用担心Stream阻塞的问题
    // await for (var fileResp in _cacheManager.getFileStream(remoteUri.toString(),
    //     headers: localReqHeaders)) {
    //   if (fileResp is FileInfo) {}
    // }


    Map<String,String> maps = {"CDN":selectLine};

    localReqHeaders.addAll(maps);

    if (reqFilter.reg == LOCAL_ALL_FILTER
        // &&localReqHeaders.containsKey(HttpHeaders.rangeHeader)
        ) {
      csPrint("_getAllBytes()...直接请求开始:${remoteUri.toString()}");
      var rangeStart = getRangeStart(localReqHeaders);
      try {
        // var oldToken = CancelTokenManager()
        //     .remove(remoteUri.toString(), rangeStart.toString());
        // oldToken?.cancel('============>already have a same request :$rangeStart');
        // var newToken = CancelTokenManager()
        //     .createToken(remoteUri.toString(), rangeStart.toString());

        var resp = await _dio.get<ResponseBody>(remoteUri.toString(),
            options: Options(
              responseType: ResponseType.stream,
              headers: localReqHeaders,
              sendTimeout: 15000,
              receiveTimeout: 15000,
            ),
            cancelToken: null);

        localReq.response.statusCode =
            resp?.statusCode ?? HttpStatus.badRequest;
        if (localReq.response.statusCode == HttpStatus.ok ||
            localReq.response.statusCode == HttpStatus.accepted ||
            localReq.response.statusCode == HttpStatus.created ||
            localReq.response.statusCode == HttpStatus.partialContent) {
          var s = resp?.data?.stream;

          bool isEncrypt = false;
          var newS = s?.map<List<int>>((buf) {
            if (rangeStart <= 0) {
              isEncrypt = _isEncryptData(buf);
              if (isEncrypt) {
                return buf.sublist(encryptMagicNumber.length);
              } else {
                return buf;
              }
            } else {
              return buf;
            }
          })?.map((buf) {
            return buf.map((it) => it ^ ENCRYPT_KEY).toList();
          });
          if (rangeStart <= 0) {
            resp.data.headers.forEach((key, values) {
              if (HttpHeaders.contentLengthHeader == key) {
                var ct = int.parse(values[0] ?? "0");
                localReq.response.headers.add(key, ct > 0 ? (ct - 6) : ct);
                csPrint("resp header ct:$key ${ct > 0 ? (ct - 6) : ct}");
              } else {
                csPrint("resp header:$key $values");
                localReq.response.headers.add(key, values);
              }
            });
          } else {
            resp.data.headers.forEach((key, values) {
              csPrint("resp header:$key $values");
            });
          }
          if (null != newS) {
            await localReq.response.addStream(newS);
            csPrint("===============>feed stream [success].......");
          } else {
            csPrint("===============>feed stream [failed].......");
            _requestErr(localReq);
          }
        }
        await localReq.response.close();
      } catch (e) {
        l.e(local_server_tag, "getRangeFile()...error:$e");
        _requestErr(localReq);
      } finally {
        // CancelTokenManager()
        //     .remove(remoteUri.toString(), rangeStart.toString());
      }
      return;
    }

    var cacheManager = _getCacheManager(remoteUri.toString());
    var s = cacheManager
        .getFileStream(remoteUri.toString(),
            headers: localReqHeaders,
            withProgress: fileExtension != LOCAL_M3U8_FILTER)
        .handleError(
      (e) {
        if (!isPreCache) {
          this.onErr?.call(e);
        }
        // TODO 是否需要处理
        l.d(local_server_tag, "getFileStream()...开始处理远端请求$remoteUri 错误");
        if (TextUtil.isNotEmpty(cacheKey) &&
            cacheKey.contains(LOCAL_M3U8_FILTER) &&
            !failedM3u8List.contains(cacheKey)) {
          l.d(local_server_tag, "getFileStream()...添加到失败错误列表$cacheKey");
          failedM3u8List.add(cacheKey);
        }
        _requestErr(localReq);
        //拦截���误之后的处理函数
      },
      // test: (error) {
      //   /// true 拦截任何错误
      //   l.e(local_server_tag, "getFileStream()...远端请求$remoteUri 发生错误:$error");
      //   _requestErr(localReq);
      //   return true;
      // }
    ).where((fileResp) {
      // 返回ture表示一直重试
      if (fileResp is FileInfo) {
        return true;
      }
      return true;
    });

    if (fileExtension.contains(LOCAL_M3U8_FILTER)) {
      // 处理m3u8
      await _handleM3u8(remoteUri, localReq, s, cacheManager);
    } else if (fileExtension.contains(LOCAL_TS_FILTER)) {
      // 处理ts
      await _handleTs(remoteUri, localReq, s, cacheManager, isPreCache);
    } else {
      // 处理所以文件
      await _handleAllFile(remoteUri, localReq, s, cacheManager, isPreCache);
    }
  }

  /// 处理ts请求
  _handleAllFile(Uri remoteUri, HttpRequest localReq, Stream<FileResponse> s,
      BaseCacheManager cacheManager, bool isPreCache) async {
    // firstIn 是一个��斥量，进入了FileInfo就不再进���DownloadProgress,两者只能进入一个
    _FIRST_IN firstIn;
    //上一次feed的字节
    int lastFeedBytes = 0;
    bool isEncrypt = false;
    final sc = s.listen((f) async {
      if (null == f) {
        l.e(local_server_tag, "handleAllFile()...$remoteUri 来了个null的鬼东西");
        _requestErr(localReq);
        return;
      }
      if (f is FileInfo) {
        var len =
            localReq.response.headers.value(HttpHeaders.contentLengthHeader);
        if (null != len) {
          l.e(local_server_tag,
              "handleAllFile()...$remoteUri already send resp to user");
          return;
        }
        if (null == firstIn) {
          firstIn = _FIRST_IN.FILE_INFO;
        }
        if (firstIn == _FIRST_IN.DOWNLOAD_PROGRESS) {
          l.e(local_server_tag,
              "handleAllFile()..$remoteUri 进入了FileInfo了，但是第一次进入的是DownLoadProgress");
          // _requestErr(localReq);
          return;
        }
        if (f.file.existsSync()) {
          localReq.response.statusCode = HttpStatus.ok;
          // var size = f.file.lengthSync();
          // localReq.response.headers.set(HttpHeaders.contentLengthHeader, size);
          // 狗日的这一句代码鸡儿有问题，并不会马上及时的返回给响应头，导致超时的概率增大
          // localReq.response.contentLength = size;
          localReq.response.headers
              .set(HttpHeaders.contentTypeHeader, "application/octet-stream");
          var fileSize = f.file.lengthSync();
          isEncrypt = _isEncryptData(
              f?.file?.openSync()?.readSync(encryptMagicNumber.length));
          var s = f.file.openRead(encryptMagicNumber.length);
          var contentLength =
              isEncrypt ? (fileSize - encryptMagicNumber.length) : fileSize;
          csPrint(
              "handleAllFile()...本地请求$remoteUri 完成fileSize:${FileUtil.byteFmt(fileSize)} isEncrypt:$isEncrypt magicLength:${encryptMagicNumber.length} send contentLength:$contentLength");
          localReq.response.headers
              .set(HttpHeaders.contentLengthHeader, contentLength);
          if (isEncrypt) {
            // var handler = StreamTransformer<List<int>, List<int>>.fromHandlers(
            //     handleData: (data, sink) {
            //   var newData = data.map((it) => it ^ ENCRYPT_KEY).toList();
            //   sink.add(newData);
            // });
            // var newS = s.transform<List<int>>(handler);
            var newS = s.map<List<int>>((data) {
              return data.map((it) => it ^ ENCRYPT_KEY).toList();
            });
            await localReq.response.addStream(newS);
          } else {
            await localReq.response.addStream(s);
          }
          await localReq.response.close();
        } else {
          l.e(local_server_tag, "handleAllFile()...本地请求$remoteUri 完成但是文件不存在");
          cacheManager.removeFile(f.originalUrl);
          _requestErr(localReq);
        }
      } else if (f is DownloadProgress) {
        if (f.totalSize <= 0) {
          csPrint("handleAllFile()...$remoteUri 没有长度不会走DownloadProgress");
          return;
        }
        if (null == firstIn) {
          firstIn = _FIRST_IN.DOWNLOAD_PROGRESS;
          localReq.response.statusCode = HttpStatus.ok;
          // localReq.response.headers
          //     .set(HttpHeaders.contentLengthHeader, f.totalSize);
          // localReq.response.contentLength = f.totalSize;
          localReq.response.headers
              .set(HttpHeaders.contentTypeHeader, "application/octet-stream");
          csPrint(
              "handleAllFile()...$remoteUri firstIn DownloadProgress length:${f.totalSize}");
        }
        // 错误的进入
        if (firstIn == _FIRST_IN.FILE_INFO) {
          l.e(local_server_tag,
              "handleAllFile()...$remoteUri 进入了DownLoadProgress 但是第一次进入的是FileInfo");
          // _requestErr(localReq);
          return;
        }
        if (lastFeedBytes <= 0) {
          if (f.downloaded >= encryptMagicNumber.length) {
            isEncrypt = _isEncryptData(f.allBytes);
            if (isEncrypt) {
              // 偏移头部魔数
              lastFeedBytes = encryptMagicNumber.length;
              localReq.response.headers.set(HttpHeaders.contentLengthHeader,
                  f.totalSize - encryptMagicNumber.length);
              csPrint(
                  "handleAllFile()...$remoteUri setContentLength:${f.totalSize - encryptMagicNumber.length}");
            } else {
              csPrint(
                  "handleAllFile()...$remoteUri setContentLength:${f.totalSize}");
              localReq.response.headers
                  .set(HttpHeaders.contentLengthHeader, f.totalSize);
            }
          } else {
            //不够一个解密头,不feed，直接return
            return;
          }
        }

        //feed 流 from lastFeedBytes ~ f.downloaded
        if (lastFeedBytes < f.downloaded && f.downloaded > 0) {
          List<int> buf = f.allBytes.sublist(lastFeedBytes, f.downloaded);
          if (isEncrypt) {
            var newBuf = buf.map((it) => it ^ ENCRYPT_KEY).toList();
            localReq.response.add(newBuf);
          } else {
            localReq.response.add(buf);
          }
          lastFeedBytes = f.downloaded;
          //文件不存在下一次ProcessDownload继续
        }

        //结束请求
        // todo need try cache
        if (f.downloaded == f.totalSize) {
          csPrint(
              "_handleAllFile()...远端请求$remoteUri download success ${FileUtil.byteFmt(f.totalSize)}");
          localReq.response.close();
        }
      } else {
        l.e(local_server_tag, "_handleAllFile()...不知道什么类型FileInfo");
        _requestErr(localReq);
      }
    });

    sc.onError((e) {
      l.e(local_server_tag, "_handleAllFile()...发生了错误:$e");
      _requestErr(localReq, sc: sc);
    });
    s.timeout(Duration(seconds: 7), onTimeout: (sink) {
      l.e(local_server_tag, "_handleAllFile()...$remoteUri 超时了7秒没有反映，现在主动关闭请求");
      _requestErr(localReq, sc: sc);
    });
  }

  /// 处理M3u8
  _handleM3u8(Uri remoteUri, HttpRequest localReq, Stream<FileResponse> s,
      BaseCacheManager cacheManager) async {
    final sc = s.listen((f) {
      if (null == f) {
        l.e(local_server_tag, "handleM3u8()...$remoteUri 来了个null���鬼东西");
        _requestErr(localReq);
        return;
      }

      if (f is FileInfo) {
        var len =
            localReq.response.headers.value(HttpHeaders.contentLengthHeader);
        if (null != len) {
          // 避���文件30天过期之后重新请求再次发送
          l.e(local_server_tag,
              "handleM3u8()...$remoteUri already send resp to user now skip");
          return;
        }
        if (f.file.existsSync()) {
          var source = f.file.readAsStringSync();
          var sourceSize = source.length;

          /// 强制ts请求通过local_server 主要是去除domin
          if (forceThroghLocalServer) {
            var lines = source.split("\n");
            var tsLine = lines.firstWhere((it) => it.contains(LOCAL_TS_FILTER),
                orElse: () => null);
            // csPrint("before source:$source");
            if (TextUtil.isNotEmpty(tsLine) && tsLine.startsWith("http")) {
              var domin = Uri.parse(tsLine ?? "").origin;
              if (TextUtil.isNotEmpty(domin)) {
                csPrint("need replace m3u8 inner host:$domin");
                source = source.replaceAll(domin, "");
                // csPrint("before source:$source");
              }
            }
          }
          var afterSize = source.length;

          // localReq.response.headers
          //     .add(HttpHeaders.contentLengthHeader, afterSize);
          // localReq.response.headers
          //     .add(HttpHeaders.contentTypeHeader, "application/octet-stream");
          localReq.response.headers
              .add(HttpHeaders.contentLengthHeader, afterSize);
          localReq.response.headers
              .add(HttpHeaders.contentTypeHeader, "application/octet-stream");
          // localReq.response.contentLength = source.length;
          localReq.response.add(source.codeUnits);
          csPrint(
              "handleM3u8()...本地请求$remoteUri 完成:sourceSize:$sourceSize afterSize:$afterSize");
          localReq.response.close();
        } else {
          l.e(local_server_tag, "handleM3u8()...本地请求$remoteUri 完成但是���件不存在");
          cacheManager.removeFile(f.originalUrl);
          _requestErr(localReq);
        }
      } else {
        // undo anything f is DownloadProgress
      }
    });
    sc.onError((e) {
      l.e(local_server_tag, "handleM3u8()...发生了错误:$e");
      _requestErr(localReq, sc: sc);
    });
    s.timeout(Duration(seconds: 7), onTimeout: (sink) {
      l.e(local_server_tag, "handleM3u8()...$remoteUri 超时了7秒没有反映，现在主动关闭请求");
      _requestErr(localReq, sc: sc);
    });
  }

  /// 处理ts请求
  _handleTs(Uri remoteUri, HttpRequest localReq, Stream<FileResponse> s,
      BaseCacheManager cacheManager, bool isPreCache) async {

    if(selectLine != null && selectLine != ""){

      //构建远程请求和请求的headers
      var remoteUri1 = remoteUri.replace(
        host: selectLine.split("https://")[1],
      );

      var remoteUriStr = remoteUri1.toString();

      debugPrint(remoteUriStr.toString());

      remoteUri = remoteUri1;

    }


    //上一次feed的字节
    int lastFeedBytes = 0;
    // firstIn 是一个互斥量，进入了FileInfo就不再进�����DownloadProgress,两者只能进入一个
    _FIRST_IN firstIn;
    var lastSpeedTime = DateTime.now();
    int lastSpeedDownloaded = 0;
    var sc = s.listen((f) async {
      if (null == f) {
        l.e(local_server_tag, "handleTs()...$remoteUri 来了个null的鬼东西");
        _requestErr(localReq);
        return;
      }

      if (f is FileInfo) {
        var len =
            localReq.response.headers.value(HttpHeaders.contentLengthHeader);
        if (null != len) {
          l.d(local_server_tag,
              "handleTs()...$remoteUri already send resp to user");
          return;
        }

        if (null == firstIn) {
          firstIn = _FIRST_IN.FILE_INFO;
        }
        if (firstIn == _FIRST_IN.DOWNLOAD_PROGRESS) {
          // l.e(local_server_tag,
          //     "handleTs()..$remoteUri 进入了FileInfo了，但是第一次进入的是DownLoadProgress");
          // _requestErr(localReq);
          return;
        }

        if (f.file.existsSync()) {
          localReq.response.statusCode = HttpStatus.ok;
          var size = f.file.lengthSync();
          localReq.response.headers.set(HttpHeaders.contentLengthHeader, size);
          // 狗日的这一句代码鸡儿有问题，并不会马上及时的返回给响应头，导致超时的概率增大
          // localReq.response.contentLength = size;
          localReq.response.headers
              .set(HttpHeaders.contentTypeHeader, "application/octet-stream");
          csPrint("handleTs()...本地请求$remoteUri 完成:${FileUtil.byteFmt(size)}");

          await localReq.response.addStream(f.file.openRead());
          localReq.response.close();
        } else {
          l.e(local_server_tag, "handleTs()...本地请求$remoteUri 完成但是文件不存在");
          cacheManager.removeFile(f.originalUrl);
          _requestErr(localReq);
        }
      } else if (f is DownloadProgress) {
        // if (LOCAL_M3U8_FILTER.contains(fileExtension) || f.totalSize <= 0) {
        if (f.totalSize <= 0) {
          csPrint("handleTs()...$remoteUri 没有长度不会走DownloadProgress");
          return;
        }
        if (null == firstIn) {
          firstIn = _FIRST_IN.DOWNLOAD_PROGRESS;
          localReq.response.statusCode = HttpStatus.ok;
          localReq.response.headers
              .set(HttpHeaders.contentLengthHeader, f.totalSize);
          // localReq.response.contentLength = f.totalSize;
          localReq.response.headers
              .set(HttpHeaders.contentTypeHeader, "application/octet-stream");
          csPrint(
              "handleTs()...$remoteUri firstIn DownloadProgress length:${f.totalSize}");
        }
        // 错误的进入
        if (firstIn == _FIRST_IN.FILE_INFO) {
          l.e(local_server_tag,
              "handleTs()...$remoteUri 进入了DownLoadProgress 但是第一次进入的是FileInfo");
          // _requestErr(localReq);
          return;
        }

        //feed 流 from lastFeedBytes ~ f.downloaded
        if (lastFeedBytes < f.downloaded && f.downloaded > 0) {
          List<int> buf = f.allBytes.sublist(lastFeedBytes, f.downloaded);
          // if (remoteUri.toString().endsWith(LOCAL_M3U8_FILTER)) {
          //   csPrint(
          //       "======>${remoteUri.toString()} feed:${buf.length} curStartPos:$lastFeedBytes totalDownloaded(endPos):${f.downloaded} totalSize:${f.totalSize}");
          // }
          localReq.response.add(buf);
          lastFeedBytes = f.downloaded;
          //文件不存在下一次ProcessDownload继续
        }

        // 显示当��下载速度
        var now = DateTime.now();
        if (null != f.downloaded &&
            now.difference(lastSpeedTime) > Duration(seconds: 1)) {
          _nowVideoSpeed = f.downloaded - lastSpeedDownloaded;
          _speedController.add(_nowVideoSpeed);
          lastSpeedTime = now;
          lastSpeedDownloaded = f.downloaded;
          csPrint(
              "handleTs()...远端请求$remoteUri 当前下载速度${FileUtil.byteSpeedFmt(_nowVideoSpeed)}");
        }
        //结束请求
        // todo need try cache
        if (f.downloaded == f.totalSize) {
          csPrint(
              "handleTs()...远端����求$remoteUri download success ${FileUtil.byteFmt(f.totalSize)}");
          localReq.response.close();
        }
      } else {
        l.e(local_server_tag, "handleTs()...不知道什么类���FileInfo");
        _requestErr(localReq);
      }
    });
    sc.onError((e) {
      l.e(local_server_tag, "handleTs()...发生了错误:$e");
      _requestErr(localReq, sc: sc);
    });
    s.timeout(Duration(seconds: 7), onTimeout: (sink) {
      l.e(local_server_tag, "handleTs()...$remoteUri 超时了7秒没有��映，现在主动关闭请求");
      _requestErr(localReq, sc: sc);
    });
  }

  /// 请求错误
  _requestErr(HttpRequest req, {StreamSubscription sc}) async {
    if (null != req) {
      // if (null == req.response.statusCode) {
      try {
        req.response.statusCode = HttpStatus.badRequest;
      } catch (e) {
        l.e(local_server_tag, "_requestErr()...setStatusCode 400");
      }
      // }
      await req.response.close();
      sc?.cancel();
    }
  }

  BaseCacheManager _getCacheManager(String url) {
    // var sc = FileUtil.getNamePrefix(url);
    if (_openSubManager && (onJoinSubCache?.call(url) ?? false)) {
      // csPrint("从用户缓存manager");
      return _subCacheManager;
    } else {
      // csPrint("从一般缓存manager");
      return _cacheManager;
    }
  }

  /// 取消m3u8和m3u8关联的��有任���
  /// 这里取���的是远程请求，不是m3u8 preload里面的task
  void cancelM3u8(String localReqPath, [dynamic reason]) {
    csPrint("cancelM3u8 $localReqPath");
    if (TextUtil.isEmpty(localReqPath)) return;
    var name = FileUtil.getName(localReqPath);
    final prefix = FileUtil.getNamePrefix(localReqPath);
    final suffix = FileUtil.getNameSuffix(localReqPath);
    if (suffix != LOCAL_M3U8_FILTER) return;

    //取消m3u8
    final m3u8CancelToken = CancelTokenManager().remove(name);
    if (null == m3u8CancelToken) return;
    csPrint("cancelM3u8()...cancel m3u8的下载:$localReqPath");
    m3u8CancelToken.cancel(reason);

    //��消ts
    final List<String> removed = [];
    CancelTokenManager()?.peekList?.forEach((it) {
      if (it.url.contains(prefix) && it.url.endsWith(LOCAL_TS_FILTER)) {
        removed.add(it.url);
        csPrint("cancelM3u8()...取消ts流的下载:$localReqPath");
        it.token.cancel(reason);
      }
    });
    for (final url in removed) {
      CancelTokenManager().remove(url);
    }
  }

  Future<FileInfo> getCacheFile(String remotePath) async {
    // String remoteUrl = getRemoteUrl(remotePath);
    if (TextUtil.isEmpty(remotePath)) return null;
    // l.i(local_server_tag, "getCacheFile()...闲时缓存策略预测需要缓��的url:$remoteUrl");
    var cacheManager = _getCacheManager(remotePath);
    var fileInfo = cacheManager.getFileFromMemory(getCacheKey(remotePath));
    if (null == fileInfo) {
      fileInfo = await cacheManager.getFileFromCache(getCacheKey(remotePath));
    }
    return fileInfo;
  }

  /// m3u8远程地址转本地地址  远程程地址格式特定要求如下：url必须以.m3u8结尾
  /// [remotePath] 远程的播放路径 /xxx/xxx.m3u8
  /// 返回localhost 127.0.0.1的地址
  String getLocalUrl(String remotePath, {Map<String, String> queryParams}) {
    // return "http://192.168.1.142:8080/video/hls/prog_index.m3u8";
    // return "http://192.168.1.142:8080/video/hlss/index.m3u8";
    // return "http://192.168.1.142:8080/video/hlss/index_abs.m3u8";
    // return "http://192.168.1.142:8080/video/hls/prog_index_1.m3u8";
    // return "http://202.60.250.122:9001/video/hls/prog_index_1.m3u8";
    // return "https://fs.lhexm.com/sp/8a/67/lf/mg/605635d590d11f0679a058dbc013bd53.mp4";
    // remotePath = "sp/r1/8p/mt/if/970dd3185c924ff29c273917615c844a.m3u8";
    if (TextUtil.isEmpty(remotePath)) return null;
    var remoteUri = Uri.parse(remotePath); //修正后的绝对��径
    if (null == remoteUri) return null;
    final dot = remoteUri.path.lastIndexOf(".");
    if (dot <= 0 || dot >= remoteUri.path.length - 1) return null;
    final fileExtension = remoteUri.path.substring(dot);
    var reqFilter = _reqFilterMap[fileExtension];
    // if (null == reqFilter) return null;
    if (remotePath.startsWith("/")) {
      // 兼容绝对路径 /sp/vid/xxxx.m3u8
      remotePath = (reqFilter?.pathPrefix ?? "") + remotePath;
    } else if (remotePath.startsWith("http")) {
      // 兼容原始http和https
      // undo https://xxx/sp/vid/xxxx.m3u8
    } else {
      // 兼容相对���径 sp/vid/xxxx.m3u8
      remotePath = (reqFilter?.pathPrefix ?? "") + "/" + remotePath;
    }
    remoteUri = Uri.parse(remotePath);
    Map<String, String> query = {};
    query.addAll(remoteUri.queryParameters);
    query.addAll(queryParams ?? {});

    // remoteUri.queryParameters.addAll(queryParams ?? {});
    // final localUri = localServerUri;
    if (!forceThroghLocalServer && remotePath.startsWith("http")) {
      return remoteUri.replace(queryParameters: query).toString();
    } else {
      //这里替换local127.0.0.1
      var localUrl = remoteUri
          .replace(
              scheme: localServerUri.scheme,
              host: localServerUri.host,
              port: localServerUri.port,
              queryParameters: query)
          .toString();
      return localUrl;
    }
  }

  /// 获取远程路径
  /// [remotePath] 远程的播放路径 /xxx/xxx.m3u8，或者本地请求
  String getRemoteUrl(String remotePath) {
    if (TextUtil.isEmpty(remotePath)) return null;
    final dot = remotePath.lastIndexOf(".");
    if (dot <= 0 || dot >= remotePath.length - 1) return null;
    final fileExtension = remotePath.substring(dot);
    var reqFilter = _reqFilterMap[fileExtension];
    if (null == reqFilter) return null;
    if (remotePath.startsWith("/")) {
      // 兼容绝对路径 sp/vid/xxxx.m3u8
      remotePath = reqFilter.pathPrefix + remotePath;
    } else if (remotePath.startsWith("http")) {
      // undo https://xxx/sp/vid/xxxx.m3u8
    } else {
      // 兼容相对路径 sp/vid/xxxx.m3u8
      remotePath = reqFilter.pathPrefix + "/" + remotePath;
    }
    var uri = Uri.parse(remotePath); //修正后的绝对路径
    if (null == uri) return null;
    //这里替换远程
    final remoteUri = uri.replace(
        scheme: reqFilter.schema, host: reqFilter.host, port: reqFilter.port);
    return remoteUri.toString();
  }
}

/// url/绝对路径和相对路径
String getCacheKey(String url) {
  assert(null != url);
  return FileUtil.getName(url);
}

// 第一次进入
enum _FIRST_IN {
  FILE_INFO,
  DOWNLOAD_PROGRESS,
}
