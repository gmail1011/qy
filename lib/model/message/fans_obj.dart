import 'fans_model.dart';

class FansObj {
  bool hasNext;
  List<FansModel> list;

  FansObj({this.hasNext, this.list});

  FansObj.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = List<FansModel>();
      json['list'].forEach((v) {
        list.add(FansModel.fromJson(v));
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