import 'top_list_up_item_model.dart';

class TopListUPModel {
  TopListUPModel({this.list});

  TopListUPModel.fromJson(dynamic json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(TopListUpItemModel.fromJson(v));
      });
    }
  }

  List<TopListUpItemModel> list;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (list != null) {
      map['list'] = list.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
