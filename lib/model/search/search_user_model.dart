/// uid : 105363
/// name : "幽灵轮滑～小兰"
/// age : 18
/// gender : "female"
/// portrait : "image/ia/e1/1j/il/5f481e450bfe491ea0537c1594a3be27.jpeg"
/// region : "长清"
/// summary : ""
/// vipLevel : 0
/// hasFollowed : true
/// fansCount : 2

class SearchUserModel {
  int uid;
  String name;
  int age;
  String gender;
  String portrait;
  String region;
  String summary;
  int vipLevel;
  bool hasFollowed;
  int fansCount;

  static SearchUserModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    SearchUserModel searchUserModelBean = SearchUserModel();
    searchUserModelBean.uid = map['uid'];
    searchUserModelBean.name = map['name'];
    searchUserModelBean.age = map['age'];
    searchUserModelBean.gender = map['gender'];
    searchUserModelBean.portrait = map['portrait'];
    searchUserModelBean.region = map['region'];
    searchUserModelBean.summary = map['summary'];
    searchUserModelBean.vipLevel = map['vipLevel'];
    searchUserModelBean.hasFollowed = map['hasFollowed'];
    searchUserModelBean.fansCount = map['fansCount'];
    return searchUserModelBean;
  }

  Map toJson() => {
        "uid": uid,
        "name": name,
        "age": age,
        "gender": gender,
        "portrait": portrait,
        "region": region,
        "summary": summary,
        "vipLevel": vipLevel,
        "hasFollowed": hasFollowed,
        "fansCount": fansCount,
      };
}
