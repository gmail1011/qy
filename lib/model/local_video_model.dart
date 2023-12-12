///本地视频存储信息
class LocalVideoModel {
  String videoID;

  //日期
  int day;

  static LocalVideoModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    LocalVideoModel bean = LocalVideoModel();
    bean.videoID = map['videoID'];
    bean.day = map["day"];
    return bean;
  }

  Map toJson() => {
        "videoID": videoID,
        "day": day,
      };
}
