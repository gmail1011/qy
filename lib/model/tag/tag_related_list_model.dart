import 'package:flutter_app/model/tag/tag_detail_model.dart';

/// count : 9

class TagRelatedListModel {
  int count;
  List<TagDetailModel> list;

  static TagRelatedListModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TagRelatedListModel tagRelatedListModelBean = TagRelatedListModel();
    tagRelatedListModelBean.count = map['count'];
    tagRelatedListModelBean.list = List()
      ..addAll(
          (map['list'] as List ?? []).map((o) => TagDetailModel.fromJson(o)));
    return tagRelatedListModelBean;
  }

  Map toJson() => {
        "count": count,
        "list": list,
      };
}
