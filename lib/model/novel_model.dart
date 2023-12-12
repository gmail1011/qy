class NovelModel {
  bool hasNext;
  List<NoveItem> list;

  NovelModel({this.hasNext, this.list});

  NovelModel.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = new List<NoveItem>();
      json['list'].forEach((v) {
        list.add(new NoveItem.fromJson(v));
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

class NoveItem {
  String id;
  String title = '';
  String fType;
  String summary;
  String contentUrl = '';
  int countPurchases;
  int countBrowse;
  int countCollect;
  bool isCollect;

  NoveItem(
      {this.id,
      this.title,
      this.fType,
      this.summary,
      this.contentUrl,
      this.countPurchases,
      this.countBrowse,
      this.countCollect,
      this.isCollect});

  NoveItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? '';
    fType = json['fType'];
    summary = json['summary'];
    countPurchases = json['countPurchases'];
    countBrowse = json['countBrowse'];
    contentUrl = json['contentUrl'] ?? '';
    countCollect = json['countCollect'];
    isCollect = json['isCollect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['fType'] = this.fType;
    data['contentUrl'] = this.contentUrl;
    data['summary'] = this.summary;
    data['countPurchases'] = this.countPurchases;
    data['countBrowse'] = this.countBrowse;
    data['countCollect'] = this.countCollect;
    data['isCollect'] = this.isCollect;
    return data;
  }
}
