import 'package:flutter_app/model/audiobook_model.dart';

class AnchorAudioBookList {
  bool hasNext;
  List<AudioBook> list;

  AnchorAudioBookList({this.hasNext, this.list});

  AnchorAudioBookList.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = new List<AudioBook>();
      json['list'].forEach((v) {
        list.add(new AudioBook.fromJson(v));
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
