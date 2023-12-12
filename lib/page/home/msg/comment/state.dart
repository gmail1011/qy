import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/message/comment_reply_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class CommentState with EagleHelper implements Cloneable<CommentState> {
  final int pageSize = Config.PAGE_SIZE;
  int pageNumber = 1;

  List<CommentReplyModel> commentReplyList;

  List<VideoModel> videoModelList = [];

  bool hasNext = false;

  @override
  CommentState clone() {
    return CommentState()
      ..pageNumber = pageNumber
      ..hasNext = hasNext
      ..videoModelList = videoModelList
      ..commentReplyList = commentReplyList;
  }
}

CommentState initState(Map<String, dynamic> args) {
  return CommentState();
}
