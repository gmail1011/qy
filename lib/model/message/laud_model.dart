import 'package:flutter_app/model/video_model.dart';


class LaudModel {
  bool hasNext;
  List<LaudItem> list;

  static LaudModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    LaudModel laudModelBean = LaudModel();
    laudModelBean.hasNext = map['hasNext'];
    laudModelBean.list = List()..addAll(
      (map['list'] as List ?? []).map((o) => LaudItem.fromMap(o))
    );
    return laudModelBean;
  }

  Map toJson() => {
    "hasNext": hasNext,
    "list": list,
  };
}

class LaudItem {
  int lUID;
  String lName;
  String lPortrait;
  String lType;
  String lTime;
  VideoModel video;

  static LaudItem fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    LaudItem listBean = LaudItem();
    listBean.lUID = map['lUID'];
    listBean.lName = map['lName'];
    listBean.lPortrait = map['lPortrait'];
    listBean.lType = map['lType'];
    listBean.lTime = map['lTime'];
    listBean.video = VideoModel.fromJson(map['video']);
    return listBean;
  }

  Map toJson() => {
    "lUID": lUID,
    "lName": lName,
    "lPortrait": lPortrait,
    "lType": lType,
    "lTime": lTime,
    "video": video,
  };

}