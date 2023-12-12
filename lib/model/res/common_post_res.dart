import 'package:flutter_app/model/video_model.dart';

///社区界面信息返回
class CommonPostRes {
  List<VideoModel> list;
  bool hasNext;

  static CommonPostRes fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    CommonPostRes commentListResBean = CommonPostRes();
    commentListResBean.list = List()..addAll((map['list'] as List ?? []).map((o) => VideoModel.fromJson(o)));
    commentListResBean.hasNext = map['hasNext'];
    return commentListResBean;
  }

  Map toJson() => {
        "list": list,
        "hasNext": hasNext,
      };
}

class CommonPostResNew {
  List<List<VideoModel>> list;
  bool hasNext;
  String version;

  static CommonPostResNew fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    CommonPostResNew commentListResBean = CommonPostResNew();
    commentListResBean.list = List<List<VideoModel>>.from(map["list"].map((x) => List<VideoModel>.from(x.map((x) => VideoModel.fromJson(x)))));
    commentListResBean.hasNext = map['hasNext'];
    commentListResBean.version = map['version'];
    return commentListResBean;
  }

  Map toJson() => {
    "list": list,
    "hasNext": hasNext,
    "version": version,
  };
}
