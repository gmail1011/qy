import 'VipCardList.dart';

class AnWangVipCard {
  AnWangVipCard({
      this.vipCardList,});

  AnWangVipCard.fromJson(dynamic json) {
    if (json['list'] != null) {
      vipCardList = [];
      json['list'].forEach((v) {
        vipCardList.add(VipCardList.fromJson(v));
      });
    }
  }
  List<VipCardList> vipCardList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (vipCardList != null) {
      map['list'] = vipCardList.map((v) => v.toJson()).toList();
    }
    return map;
  }

}