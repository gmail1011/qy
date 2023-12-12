import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TagState with EagleHelper implements Cloneable<TagState> {
  BaseRequestController baseRequestController = BaseRequestController();
  BaseRequestController newRequestController = BaseRequestController();
  RefreshController refreshController = RefreshController();
  RefreshController newRefreshController = RefreshController();
  ScrollController scrollController = new ScrollController();
  List<LiaoBaTagsDetailDataVideos> videoModelList = [];
  List<LiaoBaTagsDetailDataVideos> newVideoModelList = [];

  TabController tabController = new TabController(length: 2, vsync: ScrollableState(), initialIndex: 0);
  int pageNumber = 1;
  int pageSize = 15;
  String tagId;
  String title;

  @override
  TagState clone() {
    TagState tagState = TagState();
    tagState.pageSize = pageSize;
    tagState.pageNumber = pageNumber;
    tagState.tagId = tagId;
    tagState.videoModelList = videoModelList;
    tagState.title = title;
    tagState.refreshController = refreshController;
    tagState.scrollController = scrollController;
    tagState.baseRequestController = baseRequestController;
    return tagState;
  }
}

TagState initState(Map<String, dynamic> args) {
  Map<String, dynamic> maps = args;
  TagState tagState = TagState();
  tagState.pageNumber = 1;
  tagState.tagId = maps['tagId'];
  tagState.title = maps['title'];
  return tagState;
}
