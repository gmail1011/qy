

import 'new_video_model_entity.dart';

class ActivityResponse{
  List<ActivityModel> list;
  bool hasNext;

  ActivityResponse.fromJson(Map<String, dynamic> json) {
    json ??= {};
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list =  [];
      json['list'].forEach((v) {
        list.add(ActivityModel.fromJson(v));
      });
    }
  }

}

class ActivityModel{
  String id;
  String title;
  String content;
  String desc;
  String start;
  String end;
  int like;
  int comment;

  ActivityModel();
  String get commentDesc{
    if((comment ?? 0) == 0){
      return "评论";
    }else{
      return comment.toString() ?? "评论";
    }
  }

  String get playCountDesc{
    if (playCount == null) return "0";
    return (playCount > 10000) ? (playCount / 10000).toStringAsFixed(1) + "w" : playCount.toString();
  }

  String get likeDesc{
    if((like ?? 0) == 0){
      return "点赞";
    }else{
      return like.toString() ?? "点赞";
    }
  }
  String image;
  ActivityJoin join;

  String sourceUrl;
  int playTime;
  int playCount;
  bool liked;
  Publisher publisher;
  String godComment;

  ActivityModel.fromJson(Map<String, dynamic> json) {
    json ??= {};
    sourceUrl = json['sourceUrl'];
    playTime = json['playTime'];
    playCount = json['playCount'];
    id = json['id'];
    liked = json['liked'];
    publisher = Publisher.fromJson(json["publisher"]);
    id = json['id'];
    image = json['image'];
    title = json['title'];
    content = json['content'];
    desc = json['desc'];
    start = json['start'];
    end = json['end'];
    like = json['like'];
    comment = json['comment'];
    godComment = json['godComment'];
    join = ActivityJoin.fromJson(json["join"]);
  }
}

class ActivityJoin{
  String link;
  String desc;


  ActivityJoin.fromJson(Map<String, dynamic> json) {
    json ??= {};
    link = json['link'];
    desc = json['desc'];
  }
}

