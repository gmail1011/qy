import 'package:flutter_app/model/video_model.dart';


class NearbyBean {
  List<VideoModel> vInfo;
  int totalPages;
  bool hasNext = false;

  static NearbyBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    NearbyBean nearbyBeanBean = NearbyBean();
    nearbyBeanBean.vInfo = List()..addAll((map['list'] as List ?? []).map((o) => VideoModel.fromJson(o)));
    nearbyBeanBean.totalPages = map['totalPages'];
    nearbyBeanBean.hasNext = map['hasNext'] ?? false;
    return nearbyBeanBean;
  }

  static NearbyBean fromJson(Map<String, dynamic> map) => fromMap(map);

  Map toJson() => {
        "list": vInfo,
        "totalPages": totalPages,
        "hasNext": hasNext,
      };

}
