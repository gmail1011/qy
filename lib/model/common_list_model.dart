

import 'package:flutter_app/model/video_model.dart';

class CommonListModel {
  bool hasNext = false;
  List<VideoModel> list;

  static CommonListModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    CommonListModel mineVideoBean = CommonListModel();
    mineVideoBean.hasNext = map['hasNext'] ?? false;
    mineVideoBean.list = List()..addAll(
      (map['list'] as List ?? []).map((o) => VideoModel.fromJson(o))
    );
    return mineVideoBean;
  }

  Map toJson() => {
    "hasNext": hasNext,
    "list": list,
  };
}
