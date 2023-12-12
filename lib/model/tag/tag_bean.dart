

import 'package:flutter_app/model/video_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TagBean {
  List<VideoModel> list;
  bool hasNext = false;
  bool hasRealData = false;
  int pageNum = 1;
  String id;
  int index = 0;

  RefreshController refreshController = RefreshController();

  static TagBean fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    TagBean tagBeanBean = TagBean();
    tagBeanBean.list = List()..addAll(
      (map['list'] as List ?? []).map((o) => VideoModel.fromJson(o))
    );
    tagBeanBean.hasNext = map['hasNext'] ?? false;
    return tagBeanBean;
  }

  Map toJson() => {
    "list": list,
    "hasNext": hasNext,
    "hasRealData": hasRealData,
    "pageNum": pageNum,
  };
}



