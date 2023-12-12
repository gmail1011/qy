import 'dart:async';
import 'dart:convert';

import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/tasks/video_download_task.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/utils/light_model.dart';

import 'cache_video_model.dart';

/// 有那些视频被缓存了的模型
const _KEY_DOWNLOAD_CACHE = "_key_download_cache${Config.DEBUG}";

/// 缓存类型为下载
const CACHED_TYPE_DOWNLOAD = 0x01; //0000 0001 长视频
/// 缓存类型为我的
const CACHED_TYPE_MINE = 0x02; //0000 0010
/// 缓存类型为喜欢
const CACHED_TYPE_LIKE = 0x04; //0000 0100
/// 缓存类型为购买
const CACHED_TYPE_BUY = 0x08; //0000 1000
/// 缓存类型掩码
const CACHED_TYPE_MASK = 0x0F; //0000 1111
///长视频
const CACHED_TYPE_FILM = 0x05;

///短视频
const CACHED_TYPE_SHORT = 0x06;

///长视频
const CACHED_TYPE_FILM_HISTORY = 0x07;

///短视频
const CACHED_TYPE_SHORT_HISTORY = 0x08;

class CachedVideoStore {
  static CachedVideoStore _instance;

  //total 缓存列表
  List<CachedVideoModel> _cachedVideos = [];

  /// 缓存列表的特征字符串
  Set<String> _scs = Set();
  Completer<List<CachedVideoModel>> _loadCompleter;

  factory CachedVideoStore() {
    if (_instance == null) {
      _instance = CachedVideoStore._();
    }
    return _instance;
  }

  CachedVideoStore._() {
    // async
    _loadDataInner();
  }

  /// 内部加载数据
  Future<List<CachedVideoModel>> _loadDataInner() async {
    if (ArrayUtil.isNotEmpty(_cachedVideos)) return _cachedVideos;
    if (null == _loadCompleter) {
      _loadCompleter = Completer();
      () async {
        var s = await lightKV.getString(_KEY_DOWNLOAD_CACHE);
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
    // if (ArrayUtil.isEmpty(datas)) return false;
    var s = json.encode(datas ?? []);
    return lightKV.setString(_KEY_DOWNLOAD_CACHE, s);
  }

  /// 获取下载缓存
  Future<List<CachedVideoModel>> getCachedVideos() async {
    var data = await _loadDataInner();
    return (data ?? [])
        .where((it) => it.cacheType & CACHED_TYPE_DOWNLOAD > 0)
        .toList();
  }

  /// 获取下载缓存
  Future<List<CachedVideoModel>> getCachedVideosByType(int cacheType) async {
    var data = await _loadDataInner();
    return (data ?? []).where((it) => it.cacheType == cacheType).toList();
  }

  /// 获取下载缓存
  List<CachedVideoModel> get getCachedVideoSync => _cachedVideos;

  ///设置下载缓存
  /// return taskId,taskId 为url地址
  String setCachedVideo(VideoModel videoModel,
      {int cacheType = CACHED_TYPE_DOWNLOAD, ProgressChanged onUpdate}) {
    if (TextUtil.isEmpty(videoModel?.sourceURL)) return null;
    var taskId = videoModel.sourceURL;
    if (!videoModel.sourceURL.endsWith(LOCAL_M3U8_FILTER)) return null;
    var prefix = FileUtil.getNamePrefix(videoModel.sourceURL);
    if (TextUtil.isEmpty(prefix)) return null;
    if (_scs.contains(prefix)) {
      if (cacheType == CACHED_TYPE_DOWNLOAD)
        showToast(msg: Lang.ALREADY_CACHED_TIP);
      return null;
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
    // async 添加到下载任务
    taskManager.addTaskToQueue(
        VideoDownloadTask(videoModel.sourceURL, taskId: taskId), onUpdate);
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
    // l.i("cache_video_store",
    //     "deleteBatch()...after delete:${_cachedVideos.length}");
    await _saveDataInner(_cachedVideos);
    _cachedVideos.clear();
    await _loadDataInner();
    // l.i("cache_video_store", "deleteBatch()...after load:${_cachedVideos.length}");
  }

  ///清除所有列表
  Future clean() {
    _scs.clear();
    _cachedVideos.clear();
    return lightKV.setString(_KEY_DOWNLOAD_CACHE, "");
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
    // return taskManager.onProgressUpdate(taskId);
  }

  ///检查视频缓存今日是否已达到10个
  Future<bool> checkVideoCachedCountInToday() async {
    List<CachedVideoModel> cachedVideoModel =
        await getCachedVideosByType(CACHED_TYPE_FILM);
    if ((cachedVideoModel ?? []).isEmpty) {
      return Future.value(false);
    }
    List<CachedVideoModel> countArr = cachedVideoModel
        .where(
            (it) => DateTimeUtil.compareTime((it.createTime ?? 0).toString()))
        .toList();

    l.e("countArr", "${countArr?.length}");
    if ((countArr?.length ?? 0) > 10) {
      return Future.value(true);
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
