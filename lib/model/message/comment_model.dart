/// uid : 109035
/// name : "游客109035"
/// gender : "male"
/// portrait : "image/ji/xj/by/oe/7a4d226e1bd64ba485488c3a96bd8fb6.jpeg"
/// hasLocked : false
/// hasBanned : false
/// vipLevel : 0
/// isVip : false
/// hasFollow : false
/// via : ""
/// createdAt : "2019-12-25T17:32:20.336+08:00"

class CommentModel {
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

  static CommentModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CommentModel messageModelBean = CommentModel();
    messageModelBean.uid = map['uid'];
    messageModelBean.name = map['name'];
    messageModelBean.gender = map['gender'];
    messageModelBean.portrait = map['portrait'];
    messageModelBean.hasLocked = map['hasLocked'];
    messageModelBean.hasBanned = map['hasBanned'];
    messageModelBean.vipLevel = map['vipLevel'];
    messageModelBean.isVip = map['isVip'];
    messageModelBean.hasFollow = map['hasFollow'];
    messageModelBean.via = map['via'];
    messageModelBean.createdAt = map['createdAt'];
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
    "isVip": isVip,
    "hasFollow": hasFollow,
    "via": via,
    "createdAt": createdAt,
  };

  static List<CommentModel> toList(List<dynamic> mapList) {
    List<CommentModel> list = new List();
    if (mapList == null) return list;
    Iterator iterator = mapList.iterator;
    while (iterator.moveNext()) {
      Map<String, dynamic> current = iterator.current;
      list.add(fromMap(current));
    }
    return list;
  }
}