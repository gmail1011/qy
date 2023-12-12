// To parse this JSON data, do
//
//     final gameBean = gameBeanFromJson(jsonString);

import 'dart:convert';

GameBean gameBeanFromJson(String str) => GameBean.fromJson(json.decode(str));

String gameBeanToJson(GameBean data) => json.encode(data.toJson());

class GameBean {
  GameBean({
    this.gameUrl,
    this.giftMoney,
  });

  String gameUrl;
  int giftMoney;

  factory GameBean.fromJson(Map<String, dynamic> json) => GameBean(
    gameUrl: json["gameURL"],
    giftMoney: json["giftMoney"],
  );

  Map<String, dynamic> toJson() => {
    "gameURL": gameUrl,
    "giftMoney": giftMoney,
  };
}
