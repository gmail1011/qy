import 'package:flutter_app/common/config/config.dart';

import '../awards_model.dart';

class WatchlistModel {
  List<WatchModel> list = [];
  bool hasNext = false;

  WatchlistModel({this.list, this.hasNext});

  WatchlistModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<WatchModel>();
      json['list'].forEach((v) {
        list.add(new WatchModel.fromJson(v));
      });
    }
    hasNext = json['hasNext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['hasNext'] = this.hasNext;
    return data;
  }
}

class WatchModel {
  int uid;
  String name;
  String gender;
  String portrait;
  bool hasLocked;
  bool hasBanned;
  int vipLevel;
  bool isVip;
  bool hasFollow;
  String via;
  String createdAt;

  int fans; // 粉丝数
  int follow; // 关注数
  int collectionCount; // 作品数
  String summary; // 个性签名
  bool superUser;
  int merchantUser;
  List<int> awards = []; //称号数组
  List<String> awardsImages = []; //称号数组图片链接
  List<AwardsExpire> awardsExpire = [];

  int works;

  WatchModel(
      {this.uid,
      this.name,
      this.gender,
      this.portrait,
      this.hasLocked,
      this.hasBanned,
      this.vipLevel,
      this.isVip,
      this.hasFollow,
      this.via,
      this.createdAt,
      this.fans,
      this.superUser,
      this.awards,
      this.summary,
      this.awardsImages,
      this.merchantUser,

        this.works,

      this.awardsExpire});

  WatchModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    gender = json['gender'];
    portrait = json['portrait'];
    hasLocked = json['hasLocked'];
    hasBanned = json['hasBanned'];
    vipLevel = json['vipLevel'];
    isVip = json['isVip'];
    hasFollow = json['hasFollow'];
    via = json['via'];
    summary = json['summary'];
    createdAt = json['createdAt'];
    fans = json['fans'];
    superUser = json['superUser'];

    works = json['works'];

    merchantUser = json['merchantUser'];
    awards = List()
      ..addAll(
        (json['awards'] as List ?? []).map((o) => o),
      );
    awards?.forEach((element) {
      Config.userAwards?.forEach((element1) {
        if (element == element1.number) {
          awardsImages.add(element1.imgUrl);
        }
      });
    });

    awardsExpire = json["awardsExpire"] == null
        ? null
        : List<AwardsExpire>.from(
            json["awardsExpire"].map((x) => AwardsExpire.fromJson(x)));

    (awardsExpire ?? []).forEach((element) {
      Config.userAwards.forEach((element1) {
        if (element.number == element1.number) {
          element.imageUrl = element1.imgUrl;
        }
      });
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['portrait'] = this.portrait;
    data['hasLocked'] = this.hasLocked;
    data['hasBanned'] = this.hasBanned;
    data['vipLevel'] = this.vipLevel;
    data['isVip'] = this.isVip;
    data['hasFollow'] = this.hasFollow;
    data['via'] = this.via;
    data['summary'] = this.summary;
    data['createdAt'] = this.createdAt;
    data['fans'] = this.fans;
    data['superUser'] = this.superUser;
    data['awards'] = this.awards;
    data['awardsImages'] = this.awardsImages;
    data['awardsExpire'] = this.awardsExpire;
    data['merchantUser'] = this.merchantUser;

    data['works'] = this.works;

    return data;
  }
}
