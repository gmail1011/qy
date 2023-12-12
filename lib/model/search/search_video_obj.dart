
import '../video_model.dart';

class SearchVideoObj {
  bool hasNext;
  List<VideoModel> list;

  SearchVideoObj({this.hasNext, this.list});

  SearchVideoObj.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = List<VideoModel>();
      json['list'].forEach((v) {
        list.add(VideoModel.fromJson(v));
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
