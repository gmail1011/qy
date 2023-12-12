import 'package:dartz/dartz.dart';
import 'package:flutter_app/common/config/config.dart';

import '../awards_model.dart';

class FansModel {
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
  bool isFans;
  int fans;
  bool superUser;
  List<int> awards = []; //称号数组
  List<String> awardsImages = []; //称号数组图片链接
  List<AwardsExpire> awardsExpire = [];

  static FansModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    FansModel messageModelBean = FansModel();
    messageModelBean.uid = map['uid'];
    messageModelBean.name = map['name'];
    messageModelBean.gender = map['gender'];
    messageModelBean.portrait = map['portrait'];
    messageModelBean.hasLocked = map['hasLocked'];
    messageModelBean.hasBanned = map['hasBanned'];
    messageModelBean.vipLevel = map['vipLevel'];
    messageModelBean.fans = map['fans'];
    messageModelBean.isVip = map['isVip'];
    messageModelBean.hasFollow = map['hasFollow'];
    messageModelBean.via = map['via'];
    messageModelBean.createdAt = map['createdAt'];
    messageModelBean.superUser = map['superUser'];
    messageModelBean.awards = List()
      ..addAll(
        (map['awards'] as List ?? []).map((o) => o),
      );
    messageModelBean.awards?.forEach((element) {
      Config.userAwards?.forEach((element1) {
        if (element == element1.number) {
          messageModelBean.awardsImages.add(element1.imgUrl);
        }
      });
    });

    messageModelBean.awardsExpire = map["awardsExpire"] == null
        ? []
        : List<AwardsExpire>.from(
            map["awardsExpire"].map((x) => AwardsExpire.fromJson(x)));

    (messageModelBean?.awardsExpire ?? []).forEach((element) {
      Config.userAwards.forEach((element1) {
        if (element.number == element1.number) {
          element.imageUrl = element1.imgUrl;
        }
      });
    });
    return messageModelBean;
  }

  Map toJson() => {
        "uid": uid,
        "name": name,
        "gender": gender,
        "portrait": portrait,
        "hasLocked": hasLocked,
        "hasBanned": hasBanned,
        "vipLevel": vipLevel,
        "fans": fans,
        "isVip": isVip,
        "hasFollow": hasFollow,
        "via": via,
        "createdAt": createdAt,
        "awards": awards,
        "superUser": superUser,
        "awardsImages": awardsImages,
        "awardsExpire": awardsExpire,
      };

  static List<FansModel> toList(List<dynamic> mapList) {
    return optionOf(mapList)
        .map((a) => a.map((e) => e as FansModel).toList())
        .getOrElse(() => []);
  }
}
