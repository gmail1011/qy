import 'dart:async';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class PostState with EagleHelper implements Cloneable<PostState> {
  int currentIndex = 0;
  ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);

  List<AdsInfoBean> adsList = [];
  bool showToTopBtn = false;

  StreamSubscription postLoadOriginEventID;

  TabController primaryTC;
  TabController payTabController;

  // 标签推荐数据
  List<VideoModel> list = [];

  /// 图片视频上传状态

  /// ;<0 表示上传失败需要重试;
  double uploadProgress = .0;

  /// 上传重试次数
  int uploadRetryCnt = 0;

  /// ;null/空状态表示可以没有正在上传的任务
  String taskId;

  /*List<String> tabList = [
    Lang.POST_HOT,
    Lang.POST_NEW,
    Lang.POST_NEARBY,
    Lang.POST_ORIGINAL,
    Lang.POST_VIP,
  ];*/

  //List<String> tabList = [];


  TextEditingController controller = new TextEditingController();

  String announce;

  /// 是否处理过系统弹窗
  bool isOnceSystemDialog = false;

  @override
  PostState clone() {
    return PostState()
      ..currentIndex = currentIndex
      ..adsList = adsList
      ..list = list
      ..scrollController = scrollController
      ..postLoadOriginEventID = postLoadOriginEventID
      ..showToTopBtn = showToTopBtn
      ..primaryTC = primaryTC
      ..uploadProgress = uploadProgress
      ..uploadRetryCnt = uploadRetryCnt
      ..taskId = taskId
      ..payTabController = payTabController
      ..controller = controller
      ..announce = announce
      ..isOnceSystemDialog = isOnceSystemDialog
      //..tabList = tabList
    ;
  }
}

PostState initState(Map<String, dynamic> args) {
  PostState postState = PostState();
  postState.primaryTC = TabController(
      initialIndex: 0,
      //length: postState.tabList.length,
      length: Config.homeDataTags.length,
      vsync: ScrollableState());
  postState.primaryTC.addListener(() {
    postState.currentIndex = postState.primaryTC.index;
  });
  postState.payTabController =
      TabController(initialIndex: 0, length: 2, vsync: ScrollableState());
  postState.list = args['initList']??[];

  return postState;
}
