class AllTags {
  AllTags({
      this.id, 
      this.tagName, 
      this.coverImg, 
      this.videoCount,
      this.hotMark});

  AllTags.fromJson(dynamic json) {
    id = json['id'];
    tagName = json['tagName'];
    coverImg = json['coverImg'];
    videoCount = json['videoCount'];
    hotMark = json['hotMark'];
  }
  String id;
  String tagName;
  String coverImg;
  int videoCount;
  String hotMark;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['tagName'] = tagName;
    map['coverImg'] = coverImg;
    map['videoCount'] = videoCount;
    map['hotMark'] = hotMark;
    return map;
  }

}