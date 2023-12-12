class AiChangeFaceMod {
  AiChangeFaceMod({
      this.id, 
      this.cover, 
      this.hotValue, 
      this.hotMark, 
      this.coin, 
      this.vipCoin,
      this.title});

  AiChangeFaceMod.fromJson(dynamic json) {
    id = json['id'];
    cover = json['cover'];
    hotValue = json['hotValue'];
    hotMark = json['hotMark'];
    coin = json['coin'];
    vipCoin = json['vipCoin'];
    title = json['title'];
  }
  String id;
  String cover;
  int hotValue;
  String hotMark;
  int coin;
  int vipCoin;
  String title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['cover'] = cover;
    map['hotValue'] = hotValue;
    map['hotMark'] = hotMark;
    map['coin'] = coin;
    map['vipCoin'] = vipCoin;
    map['title'] = title;
    return map;
  }

}