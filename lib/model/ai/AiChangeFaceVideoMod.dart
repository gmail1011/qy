import 'package:flutter_app/global_store/store.dart';

class AiChangeFaceVideoMod {
  AiChangeFaceVideoMod({
      this.id, 
      this.title, 
      this.sourceURL, 
      this.status, 
      this.playTime, 
      this.cover, 
      this.type, 
      this.moduleType, 
      this.hotValue, 
      this.hotMark, 
      this.coin, 
      this.vipCoin,});

  AiChangeFaceVideoMod.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    sourceURL = json['sourceURL'];
    status = json['status'];
    playTime = json['playTime'];
    cover = json['cover'];
    type = json['type'];
    moduleType = json['moduleType'];
    hotValue = json['hotValue'];
    hotMark = json['hotMark'];
    coin = json['coin'];
    vipCoin = json['vipCoin'];
  }
  String id;
  String title;
  String sourceURL;
  int status;
  int playTime;
  String cover;
  String type;
  int moduleType;
  int hotValue;
  String hotMark;
  int get realCoin {
    if(GlobalStore.isVIP()){
      return vipCoin;
    }
    return coin;
  }
  int coin;
  int vipCoin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['sourceURL'] = sourceURL;
    map['status'] = status;
    map['playTime'] = playTime;
    map['cover'] = cover;
    map['type'] = type;
    map['moduleType'] = moduleType;
    map['hotValue'] = hotValue;
    map['hotMark'] = hotMark;
    map['coin'] = coin;
    map['vipCoin'] = vipCoin;
    return map;
  }

}