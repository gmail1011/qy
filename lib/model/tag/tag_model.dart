//File: 标签数据模型

import 'package:flutter_app/model/video_model.dart';

/// 标签的状态
enum TagStatus {
  normal,
  hot, // 热
  newTag, // 新
}

class TagModel {
  ///标签ID
  String id = "";

  ///标签名
  String tagName = "";

  ///标签图片
  String coverImageURL = "";

  ///标签图片str
  String coverImageURLStr = "";

  ///标签描述
  String desc = "";

  ///标签总点击数
  int rating = 0;

  ///是否收藏
  bool isCollect = false;

  ///播放次数
  int playCount = 0;

  ///标签的状态 1、热 2、新
  TagStatus type = TagStatus.normal;

  ///视频列表
  List<VideoModel> videoModelList;

  String publishUid = "";

  /// 搜索->热搜 类型
  String types;
}
