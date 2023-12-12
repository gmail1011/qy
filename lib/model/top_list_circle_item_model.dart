class TopListCircleItemModel {
  TopListCircleItemModel({
      this.id, 
      this.type, 
      this.year, 
      this.serialNo, 
      this.title, 
      this.author, 
      this.vidCount, 
      this.createAt, 
      this.updateAt,});

  TopListCircleItemModel.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    year = json['year'];
    serialNo = json['serialNo'];
    title = json['title'];
    author = json['author'];
    vidCount = json['vidCount'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }
  String id;
  String type;
  String year;
  int serialNo;
  String title;
  String author;
  int vidCount;
  String createAt;
  String updateAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['year'] = year;
    map['serialNo'] = serialNo;
    map['title'] = title;
    map['author'] = author;
    map['vidCount'] = vidCount;
    map['createAt'] = createAt;
    map['updateAt'] = updateAt;
    return map;
  }

}