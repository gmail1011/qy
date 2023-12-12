class PublishTradeMediaModel {
  PublishTradeMediaModel({
      this.sourceID, 
      this.md5, 
      this.type, 
      this.src, 
      this.height, 
      this.width,});

  PublishTradeMediaModel.fromJson(dynamic json) {
    sourceID = json['sourceID'];
    md5 = json['md5'];
    type = json['type'];
    src = json['src'];
    height = json['height'];
    width = json['width'];
  }
  String sourceID;
  String md5;
  String type;
  String src;
  int height;
  int width;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sourceID'] = sourceID;
    map['md5'] = md5;
    map['type'] = type;
    map['src'] = src;
    map['height'] = height;
    map['width'] = width;
    return map;
  }

}