import 'package:flutter_app/model/video_model.dart';

///推荐界面信息返回
class RecommendListRes {
  List<VideoModel> vInfo;
  bool hasNext;
  int totalPages;

  static RecommendListRes fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    RecommendListRes commentListResBean = RecommendListRes();
    commentListResBean.vInfo = List()..addAll((map['vInfos'] as List ?? []).map((o) => VideoModel.fromJson(o)));
    commentListResBean.totalPages = map['totalPages'];
    commentListResBean.hasNext = map['hasNext'];
    return commentListResBean;
  }

  Map toJson() => {
        "vInfos": vInfo,
        "totalPages": totalPages,
        "hasNext":hasNext,
      };
}
