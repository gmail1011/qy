import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_buy/page.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_dynamic/page.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_work/page.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'component/personal_like/page.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;

class VideoUserCenterState with EagleHelper implements Cloneable<VideoUserCenterState> {
  int uid;

  UserInfoModel userInfoModel;

  TabController tabController;

  List<Widget> pageList;

  String uniqueID;

  List<String> tabTitle = [
    Lang.WORK_TEXT,
    //Lang.DYNAMIC_TEXT,SQUARE_TEXT
    Lang.SQUARE_TEXT,
    Lang.BUY_TEXT,
    Lang.LIKE_TEXT,
  ];

  ScrollController scrollController;

  List<String> picList = [];

  bool showToTopBtn = false;

  bool showFollowBtn = false;
  bool enableShowFollowBtn = true;

  bool isFollowed = false;
  //Uc 所属于的视频类型
  VideoListType type;

  bool isWaiting = false;
  VideoModel videoModel;

  @override
  VideoUserCenterState clone() {
    return VideoUserCenterState()
      ..userInfoModel = userInfoModel
      ..uid = uid
      ..pageList = pageList
      ..tabTitle = tabTitle
      ..isWaiting = isWaiting
      ..scrollController = scrollController
      ..picList = picList
      ..uniqueID = uniqueID
      ..showFollowBtn = showFollowBtn
      ..showToTopBtn = showToTopBtn
      ..enableShowFollowBtn = enableShowFollowBtn
      ..isFollowed = isFollowed
      ..tabController = tabController
      ..type = type
      ..videoModel = videoModel;
  }
}

VideoUserCenterState initState(Map<String, dynamic> args) {
  VideoUserCenterState newState = VideoUserCenterState();
  if (args.containsKey('uid')) {
    newState.uid = args['uid'];
  }

  newState.type = args.containsKey(KEY_VIDEO_LIST_TYPE)
      ? args[KEY_VIDEO_LIST_TYPE]
      : VideoListType.NONE;

  assert(args.containsKey('uniqueId'));
  newState.uniqueID = args['uniqueId'];
  newState.pageList = [
    extended.NestedScrollViewInnerScrollPositionKeyWidget(
      Key('Tab0'),
      UserWorkPostPage()
          .buildPage({'uid': newState.uid, 'uniqueId': newState.uniqueID}),
    ),
    extended.NestedScrollViewInnerScrollPositionKeyWidget(
      Key('Tab1'),
      UserDynamicPostPage()
          .buildPage({'uid': newState.uid, 'uniqueId': newState.uniqueID}),
    ),
    extended.NestedScrollViewInnerScrollPositionKeyWidget(
      Key('Tab2'),
      UserBuyPostPage()
          .buildPage({'uid': newState.uid, 'uniqueId': newState.uniqueID}),
    ),
    extended.NestedScrollViewInnerScrollPositionKeyWidget(
      Key('Tab3'),
      UserLikePostPage()
          .buildPage({'uid': newState.uid, 'uniqueId': newState.uniqueID}),
    ),
  ];
  newState.scrollController = ScrollController(initialScrollOffset: 0.0);
  newState.tabController = TabController(
      initialIndex: 0,
      length: newState.pageList.length,
      vsync: ScrollableState());

  return newState;
}
