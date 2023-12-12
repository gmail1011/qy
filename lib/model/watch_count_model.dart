class WatchCount {
  int watchCount;
  bool isCan;

  static WatchCount fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    WatchCount watchCountobj = WatchCount();
    watchCountobj.watchCount = map['watchCount'];
    watchCountobj.isCan = map['isCan'];
    return watchCountobj;
  }

  Map toJson() => {
        "watchCount": watchCount,
        "isCan": isCan,
      };
}
