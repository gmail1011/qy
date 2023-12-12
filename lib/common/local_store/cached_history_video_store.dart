import 'dart:async';
import 'dart:convert';

import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/utils/light_model.dart';

import 'cache_video_model.dart';

/// 有那些视频被缓存了的模型
const _KEY_HISTORY_CACHE = "_key_history_cache${Config.DEBUG}";

///长视频
const HISTORY_CACHED_FILM = 0x09;

///短视频
const HISTORY_CACHED_SHORT = 0x08;

///历史记录缓存
class CachedHistoryVideoStore {
  static CachedHistoryVideoStore _instance;

  //total 缓存列表
  List<CachedVideoModel> _cachedVideos = [];

  /// 缓存列表的特征字符串
  Set<String> _scs = Set();
  Completer<List<CachedVideoModel>> _loadCompleter;

  factory CachedHistoryVideoStore() {
    if (_instance == null) {
      _instance = CachedHistoryVideoStore._();
    }
    return _instance;
  }

  CachedHistoryVideoStore._() {
    // async
    _loadDataInner();
  }

  /// 内部加载数据
  Future<List<CachedVideoModel>> _loadDataInner() async {
    if (ArrayUtil.isNotEmpty(_cachedVideos)) return _cachedVideos;
    if (null == _loadCompleter) {
      _loadCompleter = Completer();
      () async {
        var s = await lightKV.getString(_KEY_HISTORY_CACHE);
        try {
          if (TextUtil.isNotEmpty(s)) {
            _cachedVideos = CachedVideoModel.toList(json.decode(s));
            _scs.clear();
            List<String> iterator = _cachedVideos
                    ?.map(
                        (it) => FileUtil.getNamePrefix(it.videoModel.sourceURL))
                    ?.toList() ??
                <String>[];
            _scs.addAll(iterator);
          }
        } catch (_) {}
        _loadCompleter.complete(_cachedVideos);
        _loadCompleter = null;
      }();
    }

    return _loadCompleter.future;
  }

  ///内部保存数据
  Future<bool> _saveDataInner(List<CachedVideoModel> datas) async {
    var s = json.encode(datas ?? []);
    return await lightKV.setString(_KEY_HISTORY_CACHE, s);
  }

  /// 获取下载缓存
  Future<List<CachedVideoModel>> getCachedVideos() async {
    List<CachedVideoModel> data = await _loadDataInner();

    return (data ?? [])
        .where((it) => it.cacheType & HISTORY_CACHED_FILM > 0)
        .toList();
  }

  /// 获取下载缓存
  Future<List<CachedVideoModel>> getCachedHistoryVideosByType(
      int cacheType) async {
    try {
      List<CachedVideoModel> data = await _loadDataInner();

      ///倒叙排列
      if ((data ?? []).isNotEmpty) {
        data.sort((a, b) {
          return b.createTime.compareTo(a.createTime);
        });
      }
      return (data ?? []).where((it) => it.cacheType == cacheType).toList();
    } catch (e) {
      return [];
    }
  }

  /// 获取下载缓存
  List<CachedVideoModel> get getCachedVideoSync => _cachedVideos;

  ///设置下载缓存
  /// return taskId,taskId 为url地址
  String setCachedVideo(VideoModel videoModel,
      {int cacheType = HISTORY_CACHED_FILM, ProgressChanged onUpdate}) {
    if (TextUtil.isEmpty(videoModel?.sourceURL)) return null;
    var taskId = videoModel.sourceURL;
    if (!videoModel.sourceURL.endsWith(LOCAL_M3U8_FILTER)) return null;
    var prefix = FileUtil.getNamePrefix(videoModel.sourceURL);
    if (TextUtil.isEmpty(prefix)) return null;
    if (_scs.contains(prefix)) {
      if (cacheType == HISTORY_CACHED_FILM ||
          cacheType == HISTORY_CACHED_SHORT) {
        return null;
      }
    }
    _scs.add(prefix);
    var cvm = CachedVideoModel();
    cvm.videoModel = videoModel;
    cvm.taskId = taskId;
    cvm.cacheType = cacheType;
    int nowTime = DateTime.now().millisecondsSinceEpoch;
    cvm.createTime = nowTime;
    _cachedVideos.add(cvm);
    _saveDataInner(_cachedVideos);
    return taskId;
  }

  /// 获取特征字符序列串
  Set<String> get specialCharacterList => _scs;

  /// 添加额外的特征字符序列
  bool addSpecialCharacter(String sc) {
    if (TextUtil.isNotEmpty(sc)) {
      var prefix = FileUtil.getNamePrefix(sc);
      if (TextUtil.isNotEmpty(prefix)) {
        _scs.add(prefix);
        return true;
      }
    }
    return false;
  }

  /// 业务层：是否在缓存列表
  /// localserver层：是否需要缓存进二级目录
  /// [path] 远程路径，也可以是taskId
  bool inCachedList(String path) {
    if (TextUtil.isEmpty(path)) return false;
    var list = _scs.where((it) => path.contains(it)).toList();
    return ArrayUtil.isNotEmpty(list);
  }

  /// 删除一批缓存视频
  /// 视频id列表
  Future deleteBatch(List<String> vids) async {
    if (ArrayUtil.isEmpty(vids)) return;
    _cachedVideos.removeWhere((it) => vids.contains(it.videoModel?.id ?? ""));
    await _saveDataInner(_cachedVideos);
    _cachedVideos.clear();
    await _loadDataInner();
  }

  ///清除所有列表
  Future clean() {
    _scs.clear();
    _cachedVideos.clear();
    return lightKV.setString(_KEY_HISTORY_CACHE, "");
  }

  // 获取当前的任务进度度
  double getNowProgress(String taskId) {
    return taskManager.getNowProgress(taskId);
  }

  // 获取任务进度的流
  Stream<double> onProgressUpdate(String taskId) {
    return taskManager.onProgressUpdate(taskId);
  }

  /// 等待任务完成
  Future waitTask(String taskId) async {
    // 等待1秒去查询状态
    await Future.delayed(Duration(seconds: 1));
    return taskManager.waitTask(taskId);
  }

  // 获取缓存状态
  CacheStatus getCacheState(String taskId) {
    if (inCachedList(taskId)) {
      var progress = taskManager.getNowProgress(taskId);
      if (progress < 1.0 && progress > 0.0) {
        return CacheStatus.CACHEING;
      } else {
        return CacheStatus.CACHED;
      }
    } else {
      return CacheStatus.UNCACHED;
    }
  }

  ///执行删除旧历史记录视频数据
  void deleleOldVideo() async {
    await checkDelOldVideo(HISTORY_CACHED_FILM);
    await checkDelOldVideo(HISTORY_CACHED_SHORT);
  }

  Future checkDelOldVideo(int cacheType) async {
    try {
      l.e("checkDelOldVideo", "start");
      List<CachedVideoModel> data =
          await getCachedHistoryVideosByType(cacheType);
      if (data.length > 100) {
        l.e("checkDelOldVideo-超过100条数据:$cacheType", "执行删除");
        List<String> vids = [];
        for (int i = 80; i < data?.length; i++) {
          vids.add(data[i].videoModel?.id);
        }
        deleteBatch(vids);
      }
      return Future.value(true);
    } catch (e) {
      l.e("checkDelOldVideo-err", "$e");
    }
    return Future.value(false);
  }
}

/// 缓存状态
enum CacheStatus {
  UNKNOW,
  UNCACHED,
  CACHEING,
  CACHED,
}
