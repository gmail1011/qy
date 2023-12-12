import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/tag/tag_bean.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TopicDetailState implements Cloneable<TopicDetailState> {
  TabController tabController =
      new TabController(length: 3, vsync: ScrollableState());

  String topicId;

  int pageNumber = 1;

  int pageSize = 14;

  int pageVideoNumber = 1;

  int pageVideoSize = 14;

  int pageMovieNumber = 1;

  int pageMovieSize = 14;

  TagBean tagBean;

  TagBean tagVideoBean;

  TagBean tagMovieBean;

  TagsBean tagsBean;


  RefreshController refreshController = RefreshController();
  RefreshController refreshVideoController = RefreshController();
  RefreshController refreshMovieController = RefreshController();


  bool isCollected;


  int playCount;

  @override
  TopicDetailState clone() {
    return TopicDetailState()
      ..tabController = tabController
      ..topicId = topicId
      ..pageSize = pageSize
      ..tagBean = tagBean
      ..tagsBean = tagsBean
      ..tagMovieBean = tagMovieBean
      ..isCollected = isCollected
      ..refreshController = refreshController
      ..refreshVideoController = refreshVideoController
      ..refreshMovieController = refreshMovieController
      ..tagVideoBean = tagVideoBean
      ..pageVideoNumber = pageVideoNumber
      ..pageVideoSize = pageVideoSize
      ..pageMovieNumber = pageMovieNumber
      ..pageMovieSize = pageMovieSize
      ..playCount = playCount
      ..pageNumber = pageNumber;
  }
}

TopicDetailState initState(Map<String, dynamic> args) {
  return TopicDetailState()..tagsBean = args["tagsBean"] ?? "";
}
