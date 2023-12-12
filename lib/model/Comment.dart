class Comment {
  Comment({
      this.uid, 
      this.name, 
      this.portrait, 
      this.cid, 
      this.content, 
      this.likeCount, 
      this.isAuthor, 
      this.createdAt,});

  Comment.fromJson(dynamic json) {
    uid = json['uid'];
    name = json['name'];
    portrait = json['portrait'];
    cid = json['cid'];
    content = json['content'];
    likeCount = json['likeCount'];
    isAuthor = json['isAuthor'];
    createdAt = json['createdAt'];
  }
  int uid;
  String name;
  String portrait;
  String cid;
  String content;
  int likeCount;
  bool isAuthor;
  String createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['name'] = name;
    map['portrait'] = portrait;
    map['cid'] = cid;
    map['content'] = content;
    map['likeCount'] = likeCount;
    map['isAuthor'] = isAuthor;
    map['createdAt'] = createdAt;
    return map;
  }

}