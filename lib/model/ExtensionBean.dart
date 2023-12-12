// To parse this JSON data, do
//
//     final extensionBean = extensionBeanFromJson(jsonString);

import 'dart:convert';

ExtensionBean extensionBeanFromJson(String str) => ExtensionBean.fromJson(json.decode(str));

String extensionBeanToJson(ExtensionBean data) => json.encode(data.toJson());

class ExtensionBean {
  ExtensionBean({
    this.code,
    this.data,
    this.hash,
    this.msg,
    this.time,
    this.tip,
  });

  int code;
  List<SelectBean> data;
  bool hash;
  String msg;
  DateTime time;
  String tip;

  factory ExtensionBean.fromJson(Map<String, dynamic> json) => ExtensionBean(
    code: json["code"],
    data: List<SelectBean>.from(json["data"].map((x) => SelectBean.fromJson(x))),
    hash: json["hash"],
    msg: json["msg"],
    time: DateTime.parse(json["time"]),
    tip: json["tip"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "hash": hash,
    "msg": msg,
    "time": time.toIso8601String(),
    "tip": tip,
  };
}

class SelectBean {
  SelectBean({
    this.popId,
    this.price,
    this.popDays,
  });

  String popId;
  int price;
  int popDays;

  factory SelectBean.fromJson(Map<String, dynamic> json) => SelectBean(
    popId: json["popId"],
    price: json["price"],
    popDays: json["popDays"],
  );

  Map<String, dynamic> toJson() => {
    "popId": popId,
    "price": price,
    "popDays": popDays,
  };
}
