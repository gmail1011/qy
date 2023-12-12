import '../video_model.dart';


class MineVideo {
  bool hasNext = false;
  List<VideoModel> list;

  static MineVideo fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    MineVideo mineVideoBean = MineVideo();
    mineVideoBean.hasNext = map['hasNext'] ?? false;
    mineVideoBean.list = List()..addAll(
      (map['list'] as List ?? []).map((o) => VideoModel.fromJson(o))
    );
    return mineVideoBean;
  }

  Map toJson() => {
    "hasNext": hasNext,
    "list": list,
  };
}
