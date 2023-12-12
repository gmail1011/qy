///广告信息
class AdsInfoBean {
  String id;
  String cover;
  String href;
  String title;
  /// 0  - 启动页广告
  /// 1 - 首页-推荐显示小广告
  /// 2 - 首页-推荐公告展示
  /// 3 - 消息界面广告
  /// 4 - 首页-热点  banner广告
  int position;

  ///同一位置使用此进行排序
  int sortCode;

  int duration;

  static AdsInfoBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    AdsInfoBean adsInfoBean = AdsInfoBean();
    adsInfoBean.id = map['id'];
    adsInfoBean.cover = map['cover'];
    adsInfoBean.href = map['href'];
    adsInfoBean.position = map['position'];
    adsInfoBean.sortCode = map['sortCode'];
    adsInfoBean.duration = map['duration'];
    adsInfoBean.title = map['title'];
    return adsInfoBean;
  }

  Map toJson() => {
        "id": id,
        "cover": cover,
        "href": href,
        "position": position,
        "sortCode": sortCode,
        "duration": duration,
        "title":title,
      };
}
