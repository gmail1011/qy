class Medias {
  Medias({
      this.type, 
      this.src, 
      this.height, 
      this.width,});

  Medias.fromJson(dynamic json) {
    type = json['type'];
    src = json['src'];
    height = json['height'];
    width = json['width'];
    sourceID = json['sourceID'];
  }
  String type;
  String src;
  int height;
  int width;
  String sourceID;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['src'] = src;
    map['height'] = height;
    map['width'] = width;
    map['sourceID'] = sourceID;
    return map;
  }

}