class PublishTagModel {
  int total;
  bool hasNext;
  List<PublishTag> publishTags;

  PublishTagModel({this.total, this.hasNext, this.publishTags});

  PublishTagModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      publishTags = new List<PublishTag>();
      json['list'].forEach((v) {
        publishTags.add(new PublishTag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['hasNext'] = this.hasNext;
    if (this.publishTags != null) {
      data['list'] = this.publishTags.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PublishTag {
  String id;
  String name;
  bool isSelected = false;
  String coverImg;
  int tPlayCount;
  PublishTag({this.id, this.name, this.isSelected = false});

  PublishTag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isSelected = json['isSelected'] ?? false;

    coverImg = json['coverImg'];
    tPlayCount = json['tPlayCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isSelected'] = this.isSelected;
    return data;
  }
}
