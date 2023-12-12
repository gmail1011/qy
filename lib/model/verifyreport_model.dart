class VerifyReportModel {
  bool hasNext;
  List<VerifyReport> list;

  VerifyReportModel({this.hasNext, this.list});

  VerifyReportModel.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = new List<VerifyReport>();
      json['list'].forEach((v) {
        list.add(new VerifyReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasNext'] = this.hasNext;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VerifyReport {
  String name;
  String avatar;
  String id;
  int uid;
  String objectType;
  String productID;
  String serviceDetails;
  List<String> imgs;
  List<String> videos;
  int processingStatus;
  String processedReceipt;
  String createdAt;
  String updatedAt;

  VerifyReport(
      {this.name,
      this.avatar,
      this.id,
      this.uid,
      this.objectType,
      this.productID,
      this.serviceDetails,
      this.imgs,
      this.videos,
      this.processingStatus,
      this.processedReceipt,
      this.createdAt,
      this.updatedAt});

  VerifyReport.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatar = json['avatar'];
    id = json['id'];
    uid = json['uid'];
    objectType = json['objectType'];
    productID = json['productID'];
    serviceDetails = json['serviceDetails'];
    imgs = json['imgs'] == null ? [] : json['imgs'].cast<String>();
    videos = json['videos'] == null ? [] : json['videos'].cast<String>();
    processingStatus = json['processingStatus'];
    processedReceipt = json['processedReceipt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['objectType'] = this.objectType;
    data['productID'] = this.productID;
    data['serviceDetails'] = this.serviceDetails;
    data['imgs'] = this.imgs;
    data['videos'] = this.videos;
    data['processingStatus'] = this.processingStatus;
    data['processedReceipt'] = this.processedReceipt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
