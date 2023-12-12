import 'package:flutter_app/page/search/hot_search_list/hot_model.dart';

class FindObj {
  bool hasNext;
  List<FindModel> list;

  FindObj({this.hasNext, this.list});

  FindObj.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = List<FindModel>();
      json['list'].forEach((v) {
        list.add(FindModel.fromJson(v));
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