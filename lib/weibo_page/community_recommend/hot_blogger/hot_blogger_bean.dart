// To parse this JSON data, do
//
//     final hotBloggerBean = hotBloggerBeanFromJson(jsonString);

import 'dart:convert';

HotBloggerBean hotBloggerBeanFromJson(String str) => HotBloggerBean.fromJson(json.decode(str));

String hotBloggerBeanToJson(HotBloggerBean data) => json.encode(data.toJson());

class HotBloggerBean {
  HotBloggerBean({
    this.code,
    this.data,
    this.hash,
    this.msg,
    this.time,
    this.tip,
  });

  int code;
  List<HotBloggerEntity> data;
  bool hash;
  String msg;
  DateTime time;
  String tip;

  factory HotBloggerBean.fromJson(Map<String, dynamic> json) => HotBloggerBean(
    code: json["code"],
    data: List<HotBloggerEntity>.from(json["data"].map((x) => HotBloggerEntity.fromJson(x))),
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

class HotBloggerEntity {
  HotBloggerEntity({
    this.uid,
    this.name,
    this.summary,
    this.gender,
    this.portrait,
    this.hasFollow,
    this.awards,
    this.superUser,
    this.merchantUser,
    this.isVip,
    this.totalWorks,
  });

  int uid;
  String name;
  String summary;
  String gender;
  String portrait;
  bool hasFollow;
  dynamic awards;
  bool superUser;
  int merchantUser;
  bool isVip;
  int totalWorks;

  factory HotBloggerEntity.fromJson(Map<String, dynamic> json) => HotBloggerEntity(
    uid: json["uid"],
    name: json["name"],
    summary: json["summary"],
    gender: json["gender"],
    portrait: json["portrait"],
    hasFollow: json["hasFollow"],
    awards: json["awards"],
    superUser: json["superUser"],
    merchantUser: json["merchantUser"],
    isVip: json["isVip"],
    totalWorks: json["totalWorks"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "summary": summary,
    "gender": gender,
    "portrait": portrait,
    "hasFollow": hasFollow,
    "awards": awards,
    "superUser": superUser,
    "merchantUser": merchantUser,
    "isVip": isVip,
    "totalWorks": totalWorks,
  };
}
