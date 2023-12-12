import 'package:flutter_app/model/tag/tag_detail_model.dart';

class TagListModel {
  List<TagDetailModel> hot;
  List<TagDetailModel> newest;
  List<TagDetailModel> playCount;
  List<TagDetailModel> community;
  int type = 0;

  static TagListModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    TagListModel tagListModelBean = TagListModel();
    tagListModelBean.hot = List()
      ..addAll(
          (map['hot'] as List ?? []).map((o) => TagDetailModel.fromJson(o)));
    tagListModelBean.newest = List()
      ..addAll(
          (map['newest'] as List ?? []).map((o) => TagDetailModel.fromJson(o)));
    tagListModelBean.playCount = List()
      ..addAll((map['playCount'] as List ?? [])
          .map((o) => TagDetailModel.fromJson(o)));

    tagListModelBean.community = List()
      ..addAll((map['community'] as List ?? [])
          .map((o) => TagDetailModel.fromJson(o)));
    return tagListModelBean;
  }

  Map toJson() => {
        "hot": hot,
        "newest": newest,
        "playCount": playCount,
        "community": community,
      };
}
