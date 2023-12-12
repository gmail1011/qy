import 'package:flutter_app/page/search/hot_search_list/hot_model.dart';

class GoldObj {
  bool hasNext;
  List<AreaModel> list;

  GoldObj({this.hasNext, this.list});

  GoldObj.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = List<AreaModel>();
      json['list'].forEach((v) {
        list.add(AreaModel.fromJson(v));
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
