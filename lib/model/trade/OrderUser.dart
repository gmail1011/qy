class OrderUser {
  OrderUser({
      this.name, 
      this.portrait,});

  OrderUser.fromJson(dynamic json) {
    name = json['name'];
    portrait = json['portrait'];
  }
  String name;
  String portrait;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['portrait'] = portrait;
    return map;
  }

}