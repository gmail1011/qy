

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
    if (like == null) return "0";
    return (like > 10000) ? (like / 10000).toStringAsFixed(1) + "w" : like.toString();
  }

  String get likeDesc{
    if((like ?? 0) == 0){
      return "点赞";
    }else{
      return like.toString() ?? "点赞";
    }
  }
  bool liked;
  String img;
  ActivityJoin join;
  ActivityModel.fromJson(Map<String, dynamic> json) {
    json ??= {};
    id = json['id'];
    img = json['img'];
    title = json['title'];
    content = json['content'];
    desc = json['desc'];
    start = json['start'];
    end = json['end'];
    like = json['like'];
    comment = json['comment'];
    liked = json['liked'];
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

