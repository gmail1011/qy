class Publisher {
  Publisher({
      this.name, 
      this.portrait,});

  Publisher.fromJson(dynamic json) {
    name = json['name'];
    portrait = json['portrait'];
    upTag = json['upTag'];
    isSuperUser = json['isSuperUser'];
  }
  String name;
  String portrait;
  String upTag;
  bool isSuperUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['portrait'] = portrait;
    map['upTag'] = upTag;
    map['isSuperUser'] = isSuperUser;
    return map;
  }

}