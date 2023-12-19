/// code : 200
/// msg : "success"
/// tip : ""

class VideoUploadResultModel {
  String id;
  String videoUri;
  String errorDesc;
  String md5;
  static VideoUploadResultModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    VideoUploadResultModel dataBean = VideoUploadResultModel();
    if(map['id'] == null && map['data'] is Map){
      map = map["data"];
    }
    dataBean.id = map['id'];
    dataBean.videoUri = map['videoUri'];
    // 语音上传返回处理
    if(map['data'] is Map){
      map = map["data"];
      dataBean.videoUri = map['fileName'];
    }
    return dataBean;
  }

  Map toJson() => {
    "id": id,
    "videoUri": videoUri,
  };
}
