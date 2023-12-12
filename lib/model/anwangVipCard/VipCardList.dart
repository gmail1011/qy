class VipCardList {
  VipCardList({
      this.id, 
      this.productName,});

  VipCardList.fromJson(dynamic json) {
    id = json['id'];
    productName = json['productName'];
  }
  String id;
  String productName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['productName'] = productName;
    return map;
  }

}