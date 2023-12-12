import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'local_server.dart';

class _Task {
  final String url;

  /// 需要缓存ts流的数量: -1,表示缓存所有的流
  final int total;

  /// 从地几个ts流开始缓存
  final int start;
  final int id;
  var executing = false;
  _Task(this.id, this.url, {this.total = 2, this.start = 0});
}

typedef TsCountChanged = void Function(int cur, int total);

class M3uPreload {
  static M3uPreload _instance;
  final Dio _dio = createDio();
  // final DioCli _dio = DioCli;

  /// 一遍播放一边下载的队列
  final _playCacheTasks = List<_Task>();

  final Map<int, Set<CancelToken>> _cancelTokens = {};
  var _executing = false;
  final int maxLen;
  int _taskId = 1;

  factory M3uPreload({int maxLen = 2}) {
    if (_instance == null) {
      _instance = M3uPreload._(maxLen);
    }
    return _instance;
  }

  M3uPreload._(this.maxLen);

  void _addCancelToken(int id, CancelToken cancelToken) {
    var set = _cancelTokens[id];
    if (set == null) {
      set = Set<CancelToken>();
      _cancelTokens[id] = set;
    }
    set.add(cancelToken);
  }

  void _removeCancelToken(int id, CancelToken cancelToken) {
    // 一个taskid 对应一个m3u8列表的任务，为什么是一个set，听说有重复的
    final set = _cancelTokens[id];
    if (set != null) {
      set.remove(cancelToken);
      if (set.isEmpty) _cancelTokens.remove(id);
    }
  }

  int _nextId() => _taskId++;

  /// 解析m3u8
  /// [needCancleToken]是否需要取消
  /// 一般来说，缓存任务可以取消，下载任务不需要取消
  Future<bool> doTask(_Task task,
      [bool needCancleToken = true, TsCountChanged onTsCnt]) async {
    final localM3u8Url = CacheServer().getLocalUrl(task.url);
    Map<String, dynamic> queryParameters = Map();
    queryParameters["isPreCache"] = true;

    final cancelToken = CancelToken();
    if (needCancleToken) _addCancelToken(task.id, cancelToken);
    final options = Options(responseType: ResponseType.plain);
    final resp = await _dio.get<String>(localM3u8Url,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken);
    if (resp is DioError) {
      l.e(local_server_tag, "_doTask()...taskUrl:${task.url} error:$resp");
      return false;
    }
    if (needCancleToken) _removeCancelToken(task.id, cancelToken);

    final source = resp.data;
    final ls = LineSplitter();

    int totalTsCnt = 0;
    for (final line in ls.convert(source)) {
      if (line.endsWith(LOCAL_TS_FILTER)) {
        totalTsCnt++;
      }
    }

    String firstLine;
    // 请求计数
    var requestCount = 0;
    for (final line in ls.convert(source)) {
      if (firstLine == null) {
        if (!line.startsWith("#EXTM3U")) return false;
        firstLine = line;
      }
      if (line.startsWith("#")) continue;

      if (line.endsWith(LOCAL_TS_FILTER)) {
        requestCount++;
        if (requestCount < task.start) {
          csPrint("skip task requestCount:$requestCount start:${task.start}");
          continue;
        }
        // handle ts
        if (line.startsWith("http")) {
          //http[s];
        } else if (line.startsWith("/")) {
          //返回的m3u8都是绝对路径,替换域名
          Uri tempUri = Uri.tryParse(localM3u8Url);
          tempUri = Uri(
              scheme: tempUri.scheme,
              host: tempUri.host,
              port: tempUri.port,
              path: line);
          final cancelToken = CancelToken();
          if (needCancleToken) _addCancelToken(task.id, cancelToken);
          //await, 表示对一个m3u8的ts文件不同时申请多个ts。 看情况修改
          var options = Options(responseType: ResponseType.bytes);
          try {
            var resp = await _dio.get<List<int>>(tempUri.toString(),
                options: options,
                queryParameters: queryParameters,
                cancelToken: cancelToken);
            if (null == resp || resp.statusCode != 200 || resp is DioError) {
              l.e("localserver", "ERROR:get ts precache error resp:$resp");
              return false;
            }
          } catch (e) {
            l.e("localserver", "ERROR:get ts precache error:$e");
            return false;
          }
          // await _client.getBytes(tempUri.toString(), cancelToken: cancelToken);
          if (needCancleToken) _removeCancelToken(task.id, cancelToken);
        } else {
          //相对路径, 替换域名和路径
          final slash = localM3u8Url.lastIndexOf("/");
          final tsUrl = "${localM3u8Url.substring(0, slash)}/$line";
          final cancelToken = CancelToken();
          if (needCancleToken) _addCancelToken(task.id, cancelToken);
          //await, 表示对一个m3u8的ts文件不同时申请多个ts。 看情况修改
          // 为什么这里没有存文件，是因为这个被转发到了localServer中处理
          var options = Options(responseType: ResponseType.bytes);
          try {
            var resp = await _dio.get<List<int>>(tsUrl,
                options: options,
                queryParameters: queryParameters,
                cancelToken: cancelToken);
            if (null == resp || resp.statusCode != 200 || resp is DioError) {
              l.e("localserver", "ERROR:get ts precache error resp:$resp");
              return false;
            }
          } catch (e) {
            l.e("localserver", "ERROR:get ts precache error:$e");
            return false;
          }
          // await _client.getBytes(tsUrl, cancelToken: cancelToken);
          if (needCancleToken) _removeCancelToken(task.id, cancelToken);
        }
        onTsCnt?.call(requestCount, totalTsCnt);
        if (task.total >= 0 && requestCount >= task.total) break;
      } // end if is ts

    }
    return true;
  }

  void _cancelTask(int taskId, [dynamic reason]) {
    final set = _cancelTokens[taskId];
    if (set != null) {
      set.forEach((CancelToken cancelToken) => cancelToken.cancel(reason));
    }
  }

  void add(String cacheUri, {int tsCnt = 1, String playingUrl}) async {
    final exists = _playCacheTasks.firstWhere((_Task e) => e.url == cacheUri,
        orElse: () => null);
    if (exists != null) return;

    if (TextUtil.isNotEmpty(playingUrl)) {
      final retain = maxLen + 1;
      while (true) {
        final length = _playCacheTasks.length;
        if (length <= retain) break;
        final first = _playCacheTasks[0];
        if (first.url == playingUrl) break;
        _cancelTask(first.id);
        _playCacheTasks.removeAt(0);
      }
    }

    final id = _nextId();
    final task = _Task(id, cacheUri, total: tsCnt);
    _playCacheTasks.add(task);

    _tryCacheExecute();
  }

  /// 基于LRU 最近使用的优先的缓存策略
  /// [cachePath] 要缓存的第一个url
  /// [cachePath2] 要缓存的第二个url
  /// [skipPath] 要跳过的url，一半为当前播放器正在播放的url,把当前正在播放的url取消了会有bug，导致播放器不动
  preCacheNext(String cachePath, {String cachePath2, String skipPath}) async {
    if (TextUtil.isEmpty(cachePath)) return;
    _playCacheTasks.removeWhere((it) {
      var notExist = (TextUtil.isNotEmpty(cachePath) &&
          it.url != cachePath &&
          TextUtil.isNotEmpty(cachePath2) &&
          it.url != cachePath2);
      if (notExist && it.url != skipPath) _cancelTask(it.id);
      return notExist;
    });
    // _cacheTasks.forEach((task) {
    //   _cancelTask(task.id);
    // });
    // _cacheTasks.clear();

    // 避免和当前正在播放视频同时并发请求
    // await Future.delayed(Duration(milliseconds: 500));

    _Task task;
    task = _playCacheTasks.firstWhere((it) => it.url == cachePath,
        orElse: () => null);
    if (null == task && TextUtil.isNotEmpty(cachePath)) {
      task = await getTask(cachePath);
      if (null != task) _playCacheTasks.add(task);
    }

    task = _playCacheTasks.firstWhere((it) => it.url == cachePath2,
        orElse: () => null);
    if (null == task && TextUtil.isNotEmpty(cachePath)) {
      task = await getTask(cachePath2);
      if (null != task) _playCacheTasks.add(task);
    }

    _tryCacheExecute();
  }

  /// 获取一个task
  /// [start] 开始的ts索引
  /// [total] 总共要下载ts的数量
  Future<_Task> getTask(String remotePath,
      [int start = 0, int total = 2]) async {
    if (TextUtil.isEmpty(remotePath)) return null;
    return _Task(_nextId(), remotePath, start: start, total: total);
  }

  void _tryCacheExecute() async {
    if (_playCacheTasks.isEmpty) return;
    if (_executing) return;
    // 永远只有一个任务在跑，他们说太多了，手机发烫
    _executing = true;
    final task = _playCacheTasks.removeAt(0);
    doTask(task).whenComplete(() async {
      if (_playCacheTasks.isEmpty) {
        csPrint("_tryExecute()...缓存队列空,开启闲时缓存");
        var url = (await CacheServer().onLocalServerIdel?.call()) ?? null;
        // var url = await recommendListModel.getNeedCachedUrl();
        if (TextUtil.isNotEmpty(url)) {
          _playCacheTasks.add(_Task(_nextId(), url, total: 2));
        }
      }
      _executing = false;
      _tryCacheExecute();
    });
  }
}
