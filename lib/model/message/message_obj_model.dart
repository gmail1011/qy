import 'package:flutter_app/model/message/message_model.dart';

class MessageObjModel {
  bool hasNext;
  List<MessageModel> list;

  MessageObjModel({this.hasNext, this.list});

  MessageObjModel.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = List<MessageModel>();
      json['list'].forEach((v) {
        list.add(MessageModel.fromJson(v));
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