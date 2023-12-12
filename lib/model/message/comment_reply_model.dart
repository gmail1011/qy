import 'package:flutter_app/model/video_model.dart';


class CommentReplyModel {
  int rUID;
  String rName;
  String rPortrait;
  String rContent;
  String rTime;
  String rType;
  VideoModel video;

  static CommentReplyModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    CommentReplyModel commentReplyModelBean = CommentReplyModel();
    commentReplyModelBean.rUID = map['rUID'];
    commentReplyModelBean.rName = map['rName'];
    commentReplyModelBean.rPortrait = map['rPortrait'];
    commentReplyModelBean.rContent = map['rContent'];
    commentReplyModelBean.rTime = map['rTime'];
    commentReplyModelBean.rType = map['rType'];
    commentReplyModelBean.video = VideoModel.fromJson(map['video']);
    return commentReplyModelBean;
  }

  Map toJson() => {
    "rUID": rUID,
    "rName": rName,
    "rPortrait": rPortrait,
    "rContent": rContent,
    "rTime": rTime,
    "rType": rType,
    "video": video,
  };

  static List<CommentReplyModel> toList(List<dynamic> mapList) {
    List<CommentReplyModel> list = new List();
    if (mapList == null) return list;
    Iterator iterator = mapList.iterator;
    while (iterator.moveNext()) {
      Map<String, dynamic> current = iterator.current;
      list.add(fromJson(current));
    }
    return list;
  }
}
