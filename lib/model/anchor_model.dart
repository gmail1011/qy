import 'package:flutter_app/model/audiobook_model.dart';

class AnchorModel {
  bool hasNext;
  List<Anchor> list;

  AnchorModel({this.hasNext, this.list});

  AnchorModel.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = new List<Anchor>();
      json['list'].forEach((v) {
        list.add(new Anchor.fromJson(v));
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
