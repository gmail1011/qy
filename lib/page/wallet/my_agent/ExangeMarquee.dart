// To parse this JSON data, do
//
//     final exchangeMarauee = exchangeMaraueeFromJson(jsonString);

import 'dart:convert';

ExchangeMarauee exchangeMaraueeFromJson(String str) => ExchangeMarauee.fromJson(json.decode(str));

String exchangeMaraueeToJson(ExchangeMarauee data) => json.encode(data.toJson());

class ExchangeMarauee {
  ExchangeMarauee({
    this.code,
    this.data,
    this.hash,
    this.msg,
    this.time,
    this.tip,
  });

  int code;
  List<Datum> data;
  bool hash;
  String msg;
  DateTime time;
  String tip;

  factory ExchangeMarauee.fromJson(Map<String, dynamic> json) => ExchangeMarauee(
    code: json["code"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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

class Datum {
  Datum({
    this.content,
    this.position,
    this.positionDesc,
  });

  String content;
  int position;
  String positionDesc;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    content: json["content"],
    position: json["position"],
    positionDesc: json["positionDesc"],
  );

  Map<String, dynamic> toJson() => {
    "content": content,
    "position": position,
    "positionDesc": positionDesc,
  };
}
