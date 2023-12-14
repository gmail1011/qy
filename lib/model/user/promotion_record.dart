class PromotionModel {
  int total;

  int sumday;

  bool hasNext;
  List<Promotion> promotionList;

  PromotionModel({this.total, this.hasNext, this.promotionList});

  PromotionModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    sumday = json['sumday'];
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      promotionList = new List<Promotion>();
      json['list'].forEach((v) {
        promotionList.add(new Promotion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;

    data['sumday'] = this.sumday;

    data['hasNext'] = this.hasNext;
    if (this.promotionList != null) {
      data['list'] = this.promotionList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Promotion {
  int userId;
  String name;
  String bindPhone;
  String createAt;
  String coverImg;

  Promotion({this.userId, this.name, this.bindPhone, this.createAt,this.coverImg});

  Promotion.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    bindPhone = json['bindPhone'];
    createAt = json['createAt'];
    coverImg = json['coverImg'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['bindPhone'] = this.bindPhone;
    data['createAt'] = this.createAt;
    data['coverImg'] = this.coverImg;
    return data;
  }
}
