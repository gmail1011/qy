class NoveDetailsModel {
  NoveDetails fiction;

  NoveDetailsModel({this.fiction});

  NoveDetailsModel.fromJson(Map<String, dynamic> json) {
    fiction =
        json['fiction'] != null ? new NoveDetails.fromJson(json['fiction']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fiction != null) {
      data['fiction'] = this.fiction.toJson();
    }
    return data;
  }
}

class NoveDetails {
  String id;
  String title;
  String fType;
  String summary;
  String contentUrl;
  bool isActive;
  int countPurchases;
  int countBrowse;
  int countCollect;
  bool isCollect;

  NoveDetails(
      {this.id,
      this.title,
      this.fType,
      this.summary,
      this.contentUrl,
      this.isActive,
      this.countPurchases,
      this.countBrowse,
      this.countCollect,
      this.isCollect});

  NoveDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    fType = json['fType'];
    summary = json['summary'];
    contentUrl = json['contentUrl'];
    isActive = json['isActive'];
    countPurchases = json['countPurchases'];
    countBrowse = json['countBrowse'];
    countCollect = json['countCollect'];
    isCollect = json['isCollect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['fType'] = this.fType;
    data['summary'] = this.summary;
    data['contentUrl'] = this.contentUrl;
    data['isActive'] = this.isActive;
    data['countPurchases'] = this.countPurchases;
    data['countBrowse'] = this.countBrowse;
    data['countCollect'] = this.countCollect;
    data['isCollect'] = this.isCollect;
    return data;
  }
}