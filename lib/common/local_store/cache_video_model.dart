import 'package:flutter_app/model/video_model.dart';

import 'cached_history_video_store.dart';

/// 缓存的数据模型
class CachedVideoModel {
  VideoModel videoModel;
  int totalTsCount = 0;
  int cachedTsCount = 0;

  /// 缓存类型
  /// type in `video_cache_model.dart`
  int cacheType;
  String taskId;
  CacheStatus status;

  ///当前时间
  int createTime = 0;

  static CachedVideoModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    CachedVideoModel dataBean = CachedVideoModel();
    dataBean.videoModel = VideoModel.fromJson(map['videoModel']);
    dataBean.cacheType = map['cacheType'];
    dataBean.totalTsCount = map['totalTsCount'];
    dataBean.cachedTsCount = map['cachedTsCount'];
    dataBean.status = map['status'];
    dataBean.taskId = map['taskId'];
    dataBean.createTime = map['createTime'];
    return dataBean;
  }

  Map toJson() => {
        'videoModel': videoModel,
        'cacheType': cacheType,
        'totalTsCount': totalTsCount,
        'cachedTsCount': cachedTsCount,
        'status': status,
        'taskId': taskId,
        'createTime': createTime,
      };

  static List<CachedVideoModel> toList(List<dynamic> mapList) {
    List<CachedVideoModel> list = new List();
    if (mapList == null) return list;
    Iterator iterator = mapList.iterator;
    while (iterator.moveNext()) {
      Map<String, dynamic> current = iterator.current;
      list.add(fromJson(current));
    }
    return list;
  }
}
