import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/page/user/video_user_center/page.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/video/main_play_list/page.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:uuid/uuid.dart';

class IndexState with EagleHelper implements Cloneable<IndexState> {
  String customServiceUrl;

  /// 是否处理过系统弹窗
  bool isOnceSystemDialog = false;

  /// 公告数据
  List<AnnounceInfoBean> announcementList;

  /// 文字公告索引
  int txtIndex;

  /// img公告索引
  int imgIndex;

  List<String> tabList = ["关注", "热门", ""];

  List<Widget> pageList;

  int currentIndex = 0;

  TabController pageController;
  String ucUniqueId = Uuid().v1();

  @override
  IndexState clone() {
    return IndexState()
      ..customServiceUrl = customServiceUrl
      ..isOnceSystemDialog = isOnceSystemDialog
      ..announcementList = announcementList
      ..txtIndex = txtIndex
      ..imgIndex = imgIndex
      ..tabList = tabList
      ..pageList = pageList
      ..pageController = pageController
      ..ucUniqueId = ucUniqueId
      ..currentIndex = currentIndex;
  }
}

IndexState initState(Map<String, dynamic> args) {
  IndexState newState = IndexState();

  newState.pageList = [
    MainPlayerListPage().buildPage({KEY_VIDEO_LIST_TYPE: VideoListType.FOLLOW}),
    MainPlayerListPage()
        .buildPage({KEY_VIDEO_LIST_TYPE: VideoListType.RECOMMEND}),
    BloggerPage(
      {
        'uniqueId': newState.ucUniqueId,
        'uid': 0,
        "recommand": true,
      },
      onTap: () {
        ///返回热门推荐
        if (newState.pageController != null) {
          newState.pageController.animateTo(1);
        }
      },
    ),
  ];
  return newState;
}
