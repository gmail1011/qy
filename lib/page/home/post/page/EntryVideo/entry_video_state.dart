import 'package:fish_redux/fish_redux.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/entry_video_entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EntryVideoState implements Cloneable<EntryVideoState> {
  int pageNumber = 1;
  int pageSize = 20;

  int pageNumber1 = 1;
  int pageSize1 = 20;

  EntryVideoData entryVideoData;

  EntryVideoData entryVideoData1;

  TimerUtil timerUtil = new TimerUtil(
    mInterval: Duration.millisecondsPerSecond,
  );

  String countDownTime;

  List<String> tabsString = ["原创榜", "UP主榜"];

  TabController tabController =
      TabController(length: 2, vsync: ScrollableState());

  String activityId;

  RefreshController refreshController = RefreshController();

  RefreshController refreshController1 = RefreshController();

  bool isBeforeToday = false;

  @override
  EntryVideoState clone() {
    return EntryVideoState()
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..pageNumber1 = pageNumber1
      ..pageSize1 = pageSize1
      ..entryVideoData = entryVideoData
      ..entryVideoData1 = entryVideoData1
      ..timerUtil = timerUtil
      ..tabController = tabController
      ..activityId = activityId
      ..refreshController = refreshController
      ..refreshController1 = refreshController1
      ..isBeforeToday = isBeforeToday
      ..countDownTime = countDownTime;
  }
}

EntryVideoState initState(Map<String, dynamic> args) {
  return EntryVideoState();
}
