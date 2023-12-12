

import 'package:flutter_app/model/message/comment_reply_model.dart';

class ReplyListModel {
  bool hasNext;
  List<CommentReplyModel> list;

  ReplyListModel({this.hasNext, this.list});

  ReplyListModel.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = List<CommentReplyModel>();
      json['list'].forEach((v) {
        list.add(CommentReplyModel.fromJson(v));
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