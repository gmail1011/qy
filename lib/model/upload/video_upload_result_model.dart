/// code : 200
/// msg : "success"
/// tip : ""

class VideoUploadResultModel {
  String id;
  String videoUri;

  static VideoUploadResultModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    VideoUploadResultModel dataBean = VideoUploadResultModel();
    dataBean.id = map['id'];
    dataBean.videoUri = map['videoUri'];
    return dataBean;
  }

  Map toJson() => {
    "id": id,
    "videoUri": videoUri,
  };
}
