class PostModuleModel {
  PostModuleModel({
      this.id, 
      this.name, 
      this.coverImg, 
      this.description, 
      this.playCount, 
      this.vidCount, 
      this.followCount,});

  PostModuleModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    coverImg = json['coverImg'];
    description = json['description'];
    playCount = json['playCount'];
    vidCount = json['vidCount'];
    followCount = json['followCount'];
  }
  String id;
  String name;
  String coverImg;
  String description;
  int playCount;
  int vidCount;
  int followCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['coverImg'] = coverImg;
    map['description'] = description;
    map['playCount'] = playCount;
    map['vidCount'] = vidCount;
    map['followCount'] = followCount;
    return map;
  }

  String get playCountDesc {
    if (playCount == null) return "";
    return ((playCount > 10000) ? (playCount / 10000).toStringAsFixed(1) + "万" : playCount.toString());
  }


  String get vidCountDesc{
    if (vidCount == null) return "";
    return ((vidCount > 10000) ? (vidCount / 10000).toStringAsFixed(1) + "万" : vidCount.toString());
  }


  String get followCountDesc{
    if (followCount == null) return "";
    return ((followCount > 10000) ? (followCount / 10000).toStringAsFixed(1) + "万" : followCount.toString());
  }

}