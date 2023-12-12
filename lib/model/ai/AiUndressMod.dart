class AiUndressMod {
  AiUndressMod({
      this.id, 
      this.cover,});

  AiUndressMod.fromJson(dynamic json) {
    id = json['id'];
    cover = json['cover'];
  }
  String id;
  String cover;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['cover'] = cover;
    return map;
  }

}