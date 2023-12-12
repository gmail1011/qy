class TopListUpItemModel {
  TopListUpItemModel({
      this.awards, 
      this.fans, 
      this.follow, 
      this.gender, 
      this.hasFollow, 
      this.isVip, 
      this.merchantUser, 
      this.name, 
      this.portrait, 
      this.summary, 
      this.superUser, 
      this.totalWorks, 
      this.uid, 
      this.upTag,});

  TopListUpItemModel.fromJson(dynamic json) {
    awards = json['awards'] != null ? json['awards'].cast<int>() : [];
    fans = json['fans'];
    follow = json['follow'];
    gender = json['gender'];
    hasFollow = json['hasFollow'];
    isVip = json['isVip'];
    merchantUser = json['merchantUser'];
    name = json['name'];
    portrait = json['portrait'];
    summary = json['summary'];
    superUser = json['superUser'];
    totalWorks = json['totalWorks'];
    uid = json['uid'];
    upTag = json['upTag'];
  }
  List<int> awards;
  int fans;
  int follow;
  String gender;
  bool hasFollow;
  bool isVip;
  int merchantUser;
  String name;
  String portrait;
  String summary;
  bool superUser;
  int totalWorks;
  int uid;
  String upTag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['awards'] = awards;
    map['fans'] = fans;
    map['follow'] = follow;
    map['gender'] = gender;
    map['hasFollow'] = hasFollow;
    map['isVip'] = isVip;
    map['merchantUser'] = merchantUser;
    map['name'] = name;
    map['portrait'] = portrait;
    map['summary'] = summary;
    map['superUser'] = superUser;
    map['totalWorks'] = totalWorks;
    map['uid'] = uid;
    map['upTag'] = upTag;
    return map;
  }

}