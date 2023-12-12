// To parse this JSON data, do
//
//     final responseResult = responseResultFromJson(jsonString);

import 'dart:convert';

ResponseResult responseResultFromJson(String str) => ResponseResult.fromJson(json.decode(str));

String responseResultToJson(ResponseResult data) => json.encode(data.toJson());

class ResponseResult {
  ResponseResult({
    this.code,
    this.data,
    this.hash,
    this.msg,
    this.time,
    this.tip,
  });

  int code;
  Data data;
  bool hash;
  String msg;
  DateTime time;
  String tip;

  factory ResponseResult.fromJson(Map<String, dynamic> json) => ResponseResult(
    code: json["code"],
    data: Data.fromJson(json["data"]),
    hash: json["hash"],
    msg: json["msg"],
    time: DateTime.parse(json["time"]),
    tip: json["tip"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
    "hash": hash,
    "msg": msg,
    "time": time.toIso8601String(),
    "tip": tip,
  };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data(
  );

  Map<String, dynamic> toJson() => {
  };
}
