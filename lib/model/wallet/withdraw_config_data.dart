// To parse this JSON data, do
//
//     final withdrawConfig = withdrawConfigFromJson(jsonString);

import 'dart:convert';

WithdrawConfig withdrawConfigFromJson(String str) =>
    WithdrawConfig.fromJson(json.decode(str));

String withdrawConfigToJson(WithdrawConfig data) => json.encode(data.toJson());

class WithdrawConfig {
  WithdrawConfig({
    this.channels,
    this.id,
    this.cashTax,
    this.coinTax,
    this.gameTax,
  });

  List<Channel> channels;
  int id;
  int cashTax;
  int coinTax;
  int gameTax;

  factory WithdrawConfig.fromJson(Map<String, dynamic> json) => WithdrawConfig(
        channels: List<Channel>.from(
            json["channels"].map((x) => Channel.fromJson(x))),
        id: json["ID"],
        cashTax: json["cashTax"],
        coinTax: json["coinTax"],
        gameTax: json["gameTax"],
      );

  Map<String, dynamic> toJson() => {
        "channels": List<dynamic>.from(channels.map((x) => x.toJson())),
        "ID": id,
        "cashTax": cashTax,
        "coinTax": coinTax,
        "gameTax": gameTax,
      };
}

class Channel {
  Channel({
    this.channelName,
    this.cid,
    this.payType,
    this.minMoney,
    this.maxMoney,
    this.qpMinMoney,
    this.qpMaxMoney,
  });

  String channelName;
  String cid;
  String payType;
  int minMoney;
  int maxMoney;
  int qpMinMoney;
  int qpMaxMoney;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        channelName: json["channelName"],
        cid: json["cid"],
        payType: json["payType"],
        minMoney: json["minMoney"],
        maxMoney: json["maxMoney"],
        qpMinMoney: json["qpMinMoney"],
        qpMaxMoney: json["qpMaxMoney"],
      );

  Map<String, dynamic> toJson() => {
        "channelName": channelName,
        "cid": cid,
        "payType": payType,
        "minMoney": minMoney,
        "maxMoney": maxMoney,
        "qpMinMoney": qpMinMoney,
        "qpMaxMoney": qpMaxMoney,
      };
}
