 import 'package:flutter_app/common/local_store/local_audio_store.dart';

class AudioRecordListModel {
  bool hasNext;
  List<AudioEpisodeRecord> list;

  AudioRecordListModel({this.hasNext, this.list});

  AudioRecordListModel.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = new List<AudioEpisodeRecord>();
      json['list'].forEach((v) {
        list.add(new AudioEpisodeRecord.fromJson(v));
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


