import 'package:flutter_app/model/video_model.dart';


class SearchTopicModel {
  List<VideoModel> list;
  String theme;
  int payCount = 0;
  bool hasNext = false;
  int playCount = 0;

  static SearchTopicModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    SearchTopicModel searchTopicModelBean = SearchTopicModel();
    searchTopicModelBean.list = List()..addAll(
      (map['list'] as List ?? []).map((o) => VideoModel.fromJson(o))
    );
    searchTopicModelBean.theme = map['theme'];
    searchTopicModelBean.payCount = map['payCount'];
    searchTopicModelBean.hasNext = map['hasNext'];
    searchTopicModelBean.playCount = map['playCount'];
    return searchTopicModelBean;
  }

  Map toJson() => {
    "list": list,
    "theme": theme,
    "payCount": payCount,
    "hasNext": hasNext,
  };
}


