// To parse this JSON data, do
//
//     final newVideoModel = newVideoModelFromJson(jsonString);

import 'dart:convert';

NewVideoModel newVideoModelFromJson(String str) =>
    NewVideoModel.fromJson(json.decode(str));

String newVideoModelToJson(NewVideoModel data) => json.encode(data.toJson());

class NewVideoModel {
  NewVideoModel({
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

  factory NewVideoModel.fromJson(Map<String, dynamic> json) => NewVideoModel(
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
  Data({
    this.list,
    this.hasNext,
    this.version,
  });

  List<List<ListElement>> list;
  bool hasNext;
  String version;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<List<ListElement>>.from(json["list"].map((x) =>
            List<ListElement>.from(x.map((x) => ListElement.fromJson(x))))),
        hasNext: json["hasNext"],
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(
            list.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "hasNext": hasNext,
        "version": version,
      };
}

class ListElement {
  ListElement({
    this.id,
    this.newsType,
    this.title,
    this.tags,
    this.sourceUrl,
    this.playTime,
    this.cover,
    this.coverThumb,
    this.seriesCover,
    this.playCount,
    this.purchaseCount,
    this.likeCount,
    this.commentCount,
    this.shareCount,
    this.coins,
    this.size,
    this.resolution,
    this.ratio,
    this.status,
    this.reason,
    this.freeTime,
    this.isHideLocation,
    this.freeArea,
    this.createdAt,
    this.reviewAt,
    this.isTopping,
    this.isRecommend,
    this.isChoosen,
    this.rewarded,
    this.publisher,
    this.location,
    this.vidStatus,
    this.comment,
    this.watch,
  });
  String get playCountDesc{
    if((playCount ?? 0) > 10000){
      return (playCount/10000).toString() + "W";
    }
    return playCount.toString();
  }
  String get likeCountDesc{
    if((likeCount ?? 0) > 10000){
      return (likeCount/10000).toString() + "W";
    }
    return likeCount.toString();
  }
  String id;
  String newsType;
  String title;
  List<Tag> tags;
  String sourceUrl;
  int playTime;
  String cover;
  String coverThumb;
  List<dynamic> seriesCover;
  int playCount;
  int purchaseCount;
  int likeCount;
  int commentCount;
  int shareCount;
  int coins;
  int size;
  String resolution;
  double ratio;
  int status;
  String reason;
  int freeTime;
  bool isHideLocation;
  bool freeArea;
  DateTime createdAt;
  DateTime reviewAt;
  bool isTopping;
  bool isRecommend;
  bool isChoosen;
  String rewarded;
  Publisher publisher;
  Location location;
  VidStatus vidStatus;
  Comment comment;
  Watch watch;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"],
        newsType: json["newsType"],
        title: json["title"],
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
        sourceUrl: json["sourceURL"],
        playTime: json["playTime"],
        cover: json["cover"],
        coverThumb: json["coverThumb"],
        seriesCover: List<dynamic>.from(json["seriesCover"].map((x) => x)),
        playCount: json["playCount"],
        purchaseCount: json["purchaseCount"],
        likeCount: json["likeCount"],
        commentCount: json["commentCount"],
        shareCount: json["shareCount"],
        coins: json["coins"],
        size: json["size"],
        resolution: json["resolution"],
        ratio: json["ratio"].toDouble(),
        status: json["status"],
        reason: json["reason"],
        freeTime: json["freeTime"],
        isHideLocation: json["isHideLocation"],
        freeArea: json["freeArea"],
        createdAt: DateTime.parse(json["createdAt"]),
        reviewAt: DateTime.parse(json["reviewAt"]),
        isTopping: json["isTopping"],
        isRecommend: json["isRecommend"],
        isChoosen: json["isChoosen"],
        rewarded: json["rewarded"],
        publisher: Publisher.fromJson(json["publisher"]),
        location: Location.fromJson(json["location"]),
        vidStatus: VidStatus.fromJson(json["vidStatus"]),
        comment: Comment.fromJson(json["comment"]),
        watch: Watch.fromJson(json["watch"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "newsType": newsType,
        "title": title,
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "sourceURL": sourceUrl,
        "playTime": playTime,
        "cover": cover,
        "coverThumb": coverThumb,
        "seriesCover": List<dynamic>.from(seriesCover.map((x) => x)),
        "playCount": playCount,
        "purchaseCount": purchaseCount,
        "likeCount": likeCount,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "coins": coins,
        "size": size,
        "resolution": resolution,
        "ratio": ratio,
        "status": status,
        "reason": reason,
        "freeTime": freeTime,
        "isHideLocation": isHideLocation,
        "freeArea": freeArea,
        "createdAt": createdAt.toIso8601String(),
        "reviewAt": reviewAt.toIso8601String(),
        "isTopping": isTopping,
        "isRecommend": isRecommend,
        "isChoosen": isChoosen,
        "rewarded": rewarded,
        "publisher": publisher.toJson(),
        "location": location.toJson(),
        "vidStatus": vidStatus.toJson(),
        "comment": comment.toJson(),
        "watch": watch.toJson(),
      };
}

class Comment {
  Comment({
    this.uid,
    this.name,
    this.portrait,
    this.cid,
    this.content,
    this.likeCount,
    this.isAuthor,
    this.createdAt,
  });

  int uid;
  String name;
  String portrait;
  String cid;
  String content;
  int likeCount;
  bool isAuthor;
  DateTime createdAt;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        uid: json["uid"],
        name: json["name"],
        portrait: json["portrait"],
        cid: json["cid"],
        content: json["content"],
        likeCount: json["likeCount"],
        isAuthor: json["isAuthor"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "portrait": portrait,
        "cid": cid,
        "content": content,
        "likeCount": likeCount,
        "isAuthor": isAuthor,
        "createdAt": createdAt.toIso8601String(),
      };
}

class Location {
  Location({
    this.id,
    this.city,
    this.cover,
    this.visit,
    this.createdAt,
  });

  String id;
  String city;
  String cover;
  int visit;
  DateTime createdAt;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        city: json["city"],
        cover: json["cover"],
        visit: json["visit"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
        "cover": cover,
        "visit": visit,
        "createdAt": createdAt.toIso8601String(),
      };
}

class Publisher {
  Publisher({
    this.uid,
    this.name,
    this.gender,
    this.portrait,
    this.hasLocked,
    this.hasBanned,
    this.vipLevel,
    this.isVip,
    this.rechargeLevel,
    this.superUser,
    this.activeValue,
    this.officialCert,
    this.age,
    this.follows,
    this.fans,
    this.hasFollowed,
  });

  int uid;
  String name;
  String gender;
  String portrait;
  bool hasLocked;
  bool hasBanned;
  int vipLevel;
  bool isVip;
  int rechargeLevel;
  bool superUser;
  int activeValue;
  bool officialCert;
  int age;
  int follows;
  int fans;
  bool hasFollowed;

  factory Publisher.fromJson(Map<String, dynamic> json) => Publisher(
        uid: json["uid"],
        name: json["name"],
        gender: json["gender"],
        portrait: json["portrait"],
        hasLocked: json["hasLocked"],
        hasBanned: json["hasBanned"],
        vipLevel: json["vipLevel"],
        isVip: json["isVip"],
        rechargeLevel: json["rechargeLevel"],
        superUser: json["superUser"],
        activeValue: json["activeValue"],
        officialCert: json["officialCert"],
        age: json["age"],
        follows: json["follows"],
        fans: json["fans"],
        hasFollowed: json["hasFollowed"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "gender": gender,
        "portrait": portrait,
        "hasLocked": hasLocked,
        "hasBanned": hasBanned,
        "vipLevel": vipLevel,
        "isVip": isVip,
        "rechargeLevel": rechargeLevel,
        "superUser": superUser,
        "activeValue": activeValue,
        "officialCert": officialCert,
        "age": age,
        "follows": follows,
        "fans": fans,
        "hasFollowed": hasFollowed,
      };
}

class Tag {
  Tag({
    this.id,
    this.name,
    this.coverImg,
    this.description,
    this.playCount,
    this.hasCollected,
  });

  String id;
  String name;
  String coverImg;
  String description;
  int playCount;
  bool hasCollected;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        name: json["name"],
        coverImg: json["coverImg"],
        description: json["description"],
        playCount: json["playCount"],
        hasCollected: json["hasCollected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "coverImg": coverImg,
        "description": description,
        "playCount": playCount,
        "hasCollected": hasCollected,
      };
}

class VidStatus {
  VidStatus({
    this.hasLiked,
    this.hasPaid,
    this.hasCollected,
    this.todayRank,
    this.todayPlayCnt,
  });

  bool hasLiked;
  bool hasPaid;
  bool hasCollected;
  int todayRank;
  int todayPlayCnt;

  factory VidStatus.fromJson(Map<String, dynamic> json) => VidStatus(
        hasLiked: json["hasLiked"],
        hasPaid: json["hasPaid"],
        hasCollected: json["hasCollected"],
        todayRank: json["todayRank"],
        todayPlayCnt: json["todayPlayCnt"],
      );

  Map<String, dynamic> toJson() => {
        "hasLiked": hasLiked,
        "hasPaid": hasPaid,
        "hasCollected": hasCollected,
        "todayRank": todayRank,
        "todayPlayCnt": todayPlayCnt,
      };
}

class Watch {
  Watch({
    this.watchCount,
    this.isWatch,
    this.isFreeWatch,
  });

  int watchCount;
  bool isWatch;
  bool isFreeWatch;

  factory Watch.fromJson(Map<String, dynamic> json) => Watch(
        watchCount: json["watchCount"],
        isWatch: json["isWatch"],
        isFreeWatch: json["isFreeWatch"],
      );

  Map<String, dynamic> toJson() => {
        "watchCount": watchCount,
        "isWatch": isWatch,
        "isFreeWatch": isFreeWatch,
      };
}
