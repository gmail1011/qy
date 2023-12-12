
class FollowUser {
  List<UsersBean> users;
  int total;
  bool hasNext = true;

  static FollowUser fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    FollowUser dataBean = FollowUser();
    dataBean.users = List()..addAll((map['list'] as List ?? []).map((o) => UsersBean.fromMap(o)));
    dataBean.total = map['total'];
    dataBean.hasNext = map['hasNext'];
    return dataBean;
  }

  Map toJson() => {
        "list": users,
        "total": total,
        "hasNext": hasNext,
      };
}

/// uid : 102294
/// name : "等你❌"
/// gender : "female"
/// portrait : "image/9a/t4/0l/z7/8942e9dd73ad4736ba716a1a222c78a8.jpeg"
/// hasLocked : false
/// hasBanned : false
/// vipLevel : 0
/// isVip : false

class UsersBean {
  int uid;
  String name;
  String gender;
  String portrait;
  bool hasLocked;
  bool hasBanned;
  int vipLevel;
  bool isVip;

  static UsersBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    UsersBean usersBean = UsersBean();
    usersBean.uid = map['uid'];
    usersBean.name = map['name'];
    usersBean.gender = map['gender'];
    usersBean.portrait = map['portrait'];
    usersBean.hasLocked = map['hasLocked'];
    usersBean.hasBanned = map['hasBanned'];
    usersBean.vipLevel = map['vipLevel'];
    usersBean.isVip = map['isVip'];
    return usersBean;
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
      };
}
