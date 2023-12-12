import 'package:flutter_app/model/video_model.dart';

class TopListModel {
  TopListModel({
    this.seriesID,
    this.rankType,
    this.list,
  });

  TopListModel.fromJson(dynamic json) {
    seriesID = json['seriesID'];
    rankType = json['rankType'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(TopListVModel.fromJson(v));
      });
    }
  }

  dynamic seriesID;
  String rankType;
  List<TopListVModel> list;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['seriesID'] = seriesID;
    map['rankType'] = rankType;
    if (list != null) {
      map['list'] = list.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class TopListVModel {
  TopListVModel({
    this.vid,
    this.ranking,
    this.videoInfo,
  });

  TopListVModel.fromJson(dynamic json) {
    vid = json['vid'];
    ranking = json['ranking'];
    if (json['videoInfo'] != null)
      videoInfo = VideoModel.fromJson(json['videoInfo']);
  }

  String vid;
  int ranking;
  VideoModel videoInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vid'] = vid;
    map['ranking'] = ranking;
    map['VideoModel'] = videoInfo.toJson();
    return map;
  }
}
