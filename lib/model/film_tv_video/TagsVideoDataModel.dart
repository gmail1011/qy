import '../liao_ba_tags_detail_entity.dart';
import 'AllSection.dart';

class TagsVideoDataModel {
  TagsVideoDataModel();

  TagsVideoDataModel.fromJson(dynamic json) {
    if (json['allVideoInfo'] != null) {
      allVideoInfo = [];
      json['allVideoInfo'].forEach((v) {
        allVideoInfo.add(LiaoBaTagsDetailDataVideos().fromJson(v));
      });
    }
    if (json['allSection'] != null) {
      allSection = [];
      json['allSection'].forEach((v) {
        allSection.add(AllSection.fromJson(v));
      });
    }
    hasNext = json['hasNext'];
  }
  List<LiaoBaTagsDetailDataVideos> allVideoInfo;
  List<AllSection> allSection;
  bool hasNext;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (allVideoInfo != null) {
      map['allVideoInfo'] = allVideoInfo.map((v) => v.toJson()).toList();
    }
    if (allSection != null) {
      map['allSection'] = allSection.map((v) => v.toJson()).toList();
    }
    map['hasNext'] = hasNext;
    return map;
  }

}