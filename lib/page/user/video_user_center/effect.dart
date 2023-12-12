import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/page/city/nearby/action.dart';
import 'package:flutter_app/page/home/index/action.dart';
import 'package:flutter_app/page/home/post/page/common_post/action.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_buy/action.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_like/action.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_work/action.dart';
import 'package:flutter_app/page/user/video_user_center/model/refresh_model.dart';
import 'package:flutter_app/page/video/main_play_list/action.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/sub_play_list/action.dart';
import 'package:flutter_app/page/video/video_list_model/recommend_list_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'component/personal_dynamic/action.dart';
import 'state.dart';

Effect<VideoUserCenterState> buildEffect() {
  return combineEffects(<Object, Effect<VideoUserCenterState>>{
    Lifecycle.initState: _initState,
    VideoUserCenterAction.onLoadUserInfo: _onLoadUserInfo,
    VideoUserCenterAction.onFollow: _onFollow,
    VideoUserCenterAction.onBack: _onBack,
    VideoUserCenterAction.onUpdateUid: _onUpdateUid,
    VideoUserCenterAction.onShowFollow: _onShowFollow,
    VideoUserCenterAction.onIsShowTopBtn: _onIsShowTopBtn,
    VideoUserCenterAction.onRefreshFollowStatus: _onRefreshFollowStatus,
    Lifecycle.dispose: _dispose,
  });
}

void _onIsShowTopBtn(Action action, Context<VideoUserCenterState> ctx) {
  print(
      "${ctx.state.showToTopBtn} xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
  if (action.payload == ctx.state.showToTopBtn) {
    return;
  }
  ctx.dispatch(VideoUserCenterActionCreator.setIsShowTopBtn(action.payload));
}

void _onRefreshFollowStatus(Action action, Context<VideoUserCenterState> ctx) {
  Map<String, dynamic> map = action.payload;
  int uid = map['uid'];
  if (ctx.state.uid == uid) {
    ctx.dispatch(
        VideoUserCenterActionCreator.refreshFollowStatus(map['isFollow']));

    ///底下三个界面刷新
    ctx.broadcast(UserDynamicPostActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(UserWorkPostActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(UserLikePostActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(UserBuyPostActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(SubPlayListActionCreator.onRefreshFollowStatus(map));
  }
}

void _onUpdateUid(Action action, Context<VideoUserCenterState> ctx) async {
  RefreshModel refreshModel = action.payload;
  String uniqueId = refreshModel.uniqueId;
  // l.i("test_ad", "uc page receive update uid");
  if (ctx.state.uniqueID != uniqueId) {
    // l.i("test_ad", "uc page receive uniqueId not equal");
    return;
  }

  if (null == refreshModel.uid && ctx.state.type == VideoListType.RECOMMEND) {
    refreshModel.uid = recommendListModel.curItem()?.publisher?.uid;
    // l.i("test_ad", "uc page reput uid:${refreshModel.uid} to refreshModel");
  }
  if (refreshModel.uid == ctx.state.uid) {
    // l.i("test_ad", "uc page receive uid is same uid:${ctx.state.uid}");
    return;
  }

  if (null == refreshModel.videoModel &&
      ctx.state.type == VideoListType.RECOMMEND) {
    // l.i("test_ad", "uc page reput videoModel to refreshModel");
    refreshModel.videoModel = recommendListModel.curItem();
  }
  bool isAd = refreshModel.videoModel?.isAd() ?? false;
  // l.i("test_ad", "uc page isAd:$isAd");
  if (isAd) {
    ctx.state.uid = refreshModel.uid;
    ctx.state.videoModel = refreshModel.videoModel;
    ctx.state.enableShowFollowBtn = false;
    ctx.dispatch(VideoUserCenterActionCreator.initView(false));
    // handleAdsInfo(ctx.context, refreshModel.videoModel?.linkUrl);
  } else {
    ctx.dispatch(VideoUserCenterActionCreator.initView());
    ctx.state.uid = refreshModel.uid;
    ctx.state.videoModel = refreshModel.videoModel;
    ctx.state.enableShowFollowBtn = true;
    _onLoadUserInfo(action, ctx);
    int currentIndex = ctx.state.tabController.index;
    if (currentIndex == 0) {
      ctx.broadcast(UserWorkPostActionCreator.onUpdateUid(refreshModel));
    } else if (currentIndex == 1) {
      ctx.broadcast(UserDynamicPostActionCreator.onUpdateUid(refreshModel));
    } else if (currentIndex == 2) {
      ctx.broadcast(UserBuyPostActionCreator.onUpdateUid(refreshModel));
    } else if (currentIndex == 3) {
      ctx.broadcast(UserLikePostActionCreator.onUpdateUid(refreshModel));
    }
  }
}

void _initState(Action action, Context<VideoUserCenterState> ctx) async {
  ctx.state.tabController.addListener(() {
    RefreshModel refreshModel = RefreshModel();
    refreshModel.uid = ctx.state.uid;
    refreshModel.uniqueId = ctx.state.uniqueID;

    int currentIndex = ctx.state.tabController.index;
    if (currentIndex == 0) {
      ctx.broadcast(UserWorkPostActionCreator.onUpdateUid(refreshModel));
    } else if (currentIndex == 1) {
      ctx.broadcast(UserDynamicPostActionCreator.onUpdateUid(refreshModel));
    } else if (currentIndex == 2) {
      ctx.broadcast(UserBuyPostActionCreator.onUpdateUid(refreshModel));
    } else if (currentIndex == 3) {
      ctx.broadcast(UserLikePostActionCreator.onUpdateUid(refreshModel));
    }
  });
  Future.delayed(Duration(milliseconds: 200), () async {
    _onLoadUserInfo(action, ctx);
    //eaglePage(ctx.state.selfId(),
          //sourceId: ctx.state.eagleId(ctx.context));
  });
  
}

void _onLoadUserInfo(Action action, Context<VideoUserCenterState> ctx) async {
  if (ctx.state.uid == null) {
    return;
  }
  UserInfoModel userInfo;
  try {
    userInfo = await netManager.client.getUserInfo(ctx.state.uid);
    ctx.dispatch(VideoUserCenterActionCreator.updateUserInfo(userInfo));
  } catch (e) {
    l.e("loadUser", "_onLoadUserInfo()...error:$e");
  }
}

///关注用户
void _onFollow(Action action, Context<VideoUserCenterState> ctx) async {
  if (ctx.state.userInfoModel == null) {
    return;
  }

  // Map<String, dynamic> parameter = {
  //   "followUID": ctx.state.uid,
  //   "isFollow": action.payload,
  // };
  ctx.dispatch(
      VideoUserCenterActionCreator.refreshFollowStatus(action.payload));
  // BaseResponse baseResponse = await getFollow(parameter);
  int followUID = ctx.state.uid;
  bool isFollow = action.payload;
  try {
    await netManager.client.getFollow(followUID, isFollow);
    ctx.state.isFollowed = action.payload;
    //刷新播放列表界面关注状态
    var map = {"uid": ctx.state.uid, "isFollow": ctx.state.isFollowed};
    ctx.broadcast(MainPlayerListActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(NearbyActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(CommonPostActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(VideoUserCenterActionCreator.onRefreshFollowStatus(map));
  } catch (e) {
    l.d('getFollow', e.toString());
    showToast(msg: e.toString());
  }
}

void _onBack(Action action, Context<VideoUserCenterState> ctx) {
  if (ctx.state.type == VideoListType.RECOMMEND) {
    ctx.broadcast(IndexActionCreator.goToRecommend());
  } else if (ctx.state.type == VideoListType.SECOND) {
    ctx.broadcast(SubPlayListActionCreator.goVideoPlayList());
  } else {
    // ctx.state.type == VideoListType.NONE or null
    safePopPage();
  }
}

void _onShowFollow(Action action, Context<VideoUserCenterState> ctx) async {
  if (ctx.state.isFollowed) {
    ///已关注则不展示
    return;
  }
  bool needShowFollowBtn = action.payload;
  if (ctx.state.showFollowBtn == needShowFollowBtn) {
    return;
  }
  if (ctx.state.isWaiting) {
    return;
  }
  if (needShowFollowBtn) {
    ctx.state.isWaiting = true;
    await Future.delayed(Duration(milliseconds: 3000));
    ctx.state.isWaiting = false;
  }
  ctx.dispatch(VideoUserCenterActionCreator.showFollowBtn(needShowFollowBtn));
}

void _dispose(Action action, Context<VideoUserCenterState> ctx) {
  ctx.state.scrollController.dispose();
  ctx.state.tabController.dispose();
}
