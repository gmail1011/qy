import 'PostModuleModel.dart';

class SearchPostModuleModel {
  SearchPostModuleModel({
      this.hasNext, 
      this.list,});

  SearchPostModuleModel.fromJson(dynamic json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(PostModuleModel.fromJson(v));
      });
    }
  }
  bool hasNext;
  List<PostModuleModel> list;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hasNext'] = hasNext;
    if (list != null) {
      map['list'] = list.map((v) => v.toJson()).toList();
    }
    return map;
  }

}