/// city : "宝鸡"
/// cover : "image/si/2s/jg/on/f3a40552bd194011987a56090b22266a.jpg"
/// visit : 14
/// createdAt : "2019-11-03T18:56:00.287+08:00"
/// isHaveCollect : false

class CityDetailModel {
  String id;
  String city;
  String cover;
  int visit;
  String createdAt;
  bool isHaveCollect;

  static CityDetailModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CityDetailModel cityDetailModelBean = CityDetailModel();
    cityDetailModelBean.id = map['id'];
    cityDetailModelBean.city = map['city'];
    cityDetailModelBean.cover = map['cover'];
    cityDetailModelBean.visit = map['visit'];
    cityDetailModelBean.createdAt = map['createdAt'];
    cityDetailModelBean.isHaveCollect = map['isHaveCollect'];
    return cityDetailModelBean;
  }

  static CityDetailModel fromJson(Map<String, dynamic> map) => fromMap(map);


  Map toJson() => {
        "id": id,
        "city": city,
        "cover": cover,
        "visit": visit,
        "createdAt": createdAt,
        "isHaveCollect": isHaveCollect,
      };

  static List<CityDetailModel> toList(List<dynamic> mapList) {
    List<CityDetailModel> list = new List();
    if (mapList == null) return list;
    Iterator iterator = mapList.iterator;
    while (iterator.moveNext()) {
      Map<String, dynamic> current = iterator.current;
      list.add(fromMap(current));
    }
    return list;
  }
}
