
import 'package:flutter_app/page/search/hot_search_list/hot_model.dart';

class HotTopicObj {
  bool hasNext;
  List<HotTopicModel> list;

  HotTopicObj({this.hasNext, this.list});

  HotTopicObj.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = List<HotTopicModel>();
      json['list'].forEach((v) {
        list.add(HotTopicModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasNext'] = this.hasNext;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
