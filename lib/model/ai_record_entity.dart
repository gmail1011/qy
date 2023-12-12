class AiRecordEntity {
  int count;
  List<AiRecordModel> list;

  AiRecordEntity({this.count, this.list});

  AiRecordEntity.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['list'] != null) {
      list = List<AiRecordModel>();
      json['list'].forEach((v) {
        list.add(AiRecordModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AiRecordModel {
  String id;
  int uid;
  String originPic;
  List<dynamic> originPics;
  List<dynamic> newPic;
  List<dynamic> picture;
  int coin;
  int status;
  String remark;
  String url;
  String updateAct;
  String createdAt;
  String updatedAt;

  String vidId;

  AiRecordModel({
    this.id,
    this.uid,
    this.originPic,
    this.originPics,
    this.newPic,
    this.coin,
    this.status,
    this.remark,
    this.url,
    this.updateAct,
    this.createdAt,
    this.updatedAt,
    this.vidId,
  });

  AiRecordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    originPic = json['originPic'];
    originPics = json['originPics']  ?? [];
    picture = json['picture']  ?? [];
    newPic = json['newPic'] ?? [];
    coin = json['coin'];
    status = json['status'];
    remark = json['remark'];
    url = json['url'];
    updateAct = json['updateAct'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    vidId = json['vidId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['originPic'] = this.originPic;
    data['originPics'] = this.originPics;
    data['picture'] = this.picture;
    data['newPic'] = this.newPic;
    data['coin'] = this.coin;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['url'] = this.url;
    data['updateAct'] = this.updateAct;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;

    data['vidId'] = this.vidId;
    return data;
  }
}
