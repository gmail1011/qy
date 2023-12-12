import 'top_list_circle_item_model.dart';

class TopListCircleModel {
  TopListCircleModel({this.total, this.hasNext, this.list});

  TopListCircleModel.fromJson(dynamic json) {
    total = json['total'];
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(TopListCircleItemModel.fromJson(v));
      });
    }
  }

  List<TopListCircleItemModel> list;
  int total;
  bool hasNext;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['hasNext'] = hasNext;
    if (list != null) {
      map['list'] = list.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
