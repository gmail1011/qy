import 'TradeItemModel.dart';

class TradeList {

  TradeList.fromJson(dynamic json) {
    total = json['total'];
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(TradeItemModel.fromJson(v));
      });
    }
  }
  int total;
  bool hasNext;
  List<TradeItemModel> list;

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