import 'dart:async';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/tag/tag_bean.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/page/tag/tag_home/compont/cell/state.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TagState with EagleHelper implements Cloneable<TagState> {
  // 测试
  num count = 0;

  // 分页
  int pageNumber = 1;

  int pageWordNumber = 1;
  int pageMovieNumber = 1;

  // 分页请求最大数量
  int pageSize = 15;

  bool isTagPage;

  TagBean tagBean;

  TagDetailModel tagDetailModel;

  List<TagItemState> tagLists;

  String tagId;

  //EasyRefreshController controller = EasyRefreshController();

  bool serverIsNormal = false;

  String errorMsg = "";

  bool isShowTitle = false;

  bool showRecorder = true;
  Timer showRecorderTimer;


  RefreshController refreshController = new RefreshController();
  RefreshController refreshWordController = new RefreshController();
  RefreshController refreshMovieController = new RefreshController();

  TabController tabController = new TabController(length: 3, vsync: ScrollableState());


  TagBean tagVideoBean;
  TagBean tagWordBean;
  TagBean tagMovieBean;


  @override
  TagState clone() {
    TagState tagState = TagState();
    tagState.tagDetailModel = tagDetailModel;
    tagState.pageSize = pageSize;
    tagState.pageNumber = pageNumber;
    tagState.pageWordNumber = pageWordNumber;
    tagState.pageMovieNumber = pageMovieNumber;
    tagState.tagId = tagId;
    tagState.refreshController = refreshController;
    tagState.refreshWordController = refreshWordController;
    tagState.refreshMovieController = refreshMovieController;
    tagState.tagBean = tagBean;
    tagState.serverIsNormal = serverIsNormal;
    tagState.errorMsg = errorMsg;
    tagState.isTagPage = isTagPage;
    tagState.isShowTitle = isShowTitle;
    tagState.tagLists = tagLists;
    tagState.showRecorder = showRecorder;
    tagState.showRecorderTimer = showRecorderTimer;
    tagState.tabController = tabController;

    tagState.tagVideoBean = tagVideoBean;
    tagState.tagWordBean = tagWordBean;
    tagState.tagMovieBean = tagMovieBean;
    return tagState;
  }
}

TagState initState(Map<String, dynamic> args) {
  Map<String, dynamic> maps = args;
  TagState tagState = TagState();
  tagState.tagLists = new List();
  tagState.pageNumber = 1;
  String routName = maps['rout'];
  if (routName == "tag") {
    tagState.isTagPage = true;
  } else {
    tagState.isTagPage = false;
  }
  tagState.tagId = maps['tagId'];
  tagState.tagBean = TagBean();
  return tagState;
}
