import 'package:flutter_app/model/video_model.dart';

class HotTopicModel {
  String tagId;
  String tagName;
  String coverImg;
  String description;
  int tPlayCount;
  List<VideoModel> vidInfo;

  static HotTopicModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    HotTopicModel listBean = HotTopicModel();
    listBean.tagId = map['tagId'];
    listBean.tagName = map['tagName'];
    listBean.coverImg = map['coverImg'];
    listBean.description = map['description'];
    listBean.tPlayCount = map['tPlayCount'];
    listBean.vidInfo = List()
      ..addAll(
          (map['VidInfo'] as List ?? []).map((o) => VideoModel.fromJson(o)));
    return listBean;
  }

  Map toJson() => {
        "tagId": tagId,
        "tagName": tagName,
        "coverImg": coverImg,
        "description": description,
        "tPlayCount": tPlayCount,
        "VidInfo": vidInfo,
      };
}

class PopularityModel {
  int uid;
  String name;
  String portrait;
  String description;
  int value;
  bool isOnclick = false;

  static PopularityModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    PopularityModel listBean = PopularityModel();
    listBean.uid = map['uid'];
    listBean.name = map['name'];
    listBean.portrait = map['portrait'];
    listBean.description = map['description'];
    listBean.value = map['value'];
    return listBean;
  }

  Map toJson() => {
        "uid": uid,
        "name": name,
        "portrait": portrait,
        "description": description,
        "value": value,
        "isOnclick": isOnclick,
      };
}

class AreaModel {
  String name; //主题名
  String types; //类型
  String cover; //封面
  int playCount = 0; //播放数
  int payCount = 0; //购买数

  static AreaModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    AreaModel toneListBean = AreaModel();
    toneListBean.name = map['name'];
    toneListBean.types = map['types'];
    toneListBean.cover = map['cover'];
    toneListBean.playCount = map['playCount'];
    toneListBean.payCount = map['payCount'];
    return toneListBean;
  }

  Map toJson() => {
        "name": name,
        "types": types,
        "cover": cover,
        "playCount": playCount,
        "payCount": payCount,
      };
}

/// 数据模型
class FindModel {
  String coverImg;
  String description;
  bool hasCollected;
  String id;
  String name;
  int playCount;

  static FindModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    FindModel tagsBean = FindModel();
    tagsBean.coverImg = map['coverImg'];
    tagsBean.description = map['description'];
    tagsBean.hasCollected = map['hasCollected'];
    tagsBean.id = map['id'];
    tagsBean.name = map['name'];
    tagsBean.playCount = map['playCount'];
    return tagsBean;
  }

  Map toJson() => {
        "coverImg": coverImg,
        "description": description,
        "hasCollected": hasCollected,
        "id": id,
        "name": name,
        "playCount": playCount,
      };
}
