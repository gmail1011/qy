import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/comment_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FilmVideoCommentState implements Cloneable<FilmVideoCommentState> {
  RefreshController refreshController = RefreshController();
  TextEditingController contentController = TextEditingController();
  BaseRequestController baseRequestController = BaseRequestController();
  FocusNode focusNode = FocusNode();
  String videoId;

  //评论列表
  List<CommentModel> commentList = [];
  String textInputTip;
  int pageIndex = 0;
  int pageSize = 10;

  bool commentHasNext = true;
  QuickSearch quickSearch;
  @override
  FilmVideoCommentState clone() {
    return FilmVideoCommentState()
      ..refreshController = refreshController
      ..contentController = contentController
      ..baseRequestController = baseRequestController
      ..commentList = commentList
      ..textInputTip = textInputTip
      ..pageIndex = pageIndex
      ..pageSize = pageSize
      ..commentHasNext = commentHasNext
      ..quickSearch = quickSearch
      ..focusNode = focusNode
      ..videoId = videoId;
  }
}

FilmVideoCommentState initState(Map<String, dynamic> args) {
  return FilmVideoCommentState()
    ..videoId = args["videoId"]
    ..quickSearch = Config.randomSearch();
}
