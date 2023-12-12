import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_work/component/action.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_work/component/state.dart';
import 'package:flutter_app/page/user/video_user_center/model/refresh_model.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:get/route_manager.dart' as Gets;
import 'action.dart';
import 'state.dart';

Effect<UserWorkPostState> buildEffect() {
  return combineEffects(<Object, Effect<UserWorkPostState>>{
    Lifecycle.initState: _onLoadData,
    WorkItemAction.onTapItem: _onTagItem,
    UserWorkPostAction.onLoadData: _onLoadData,
    UserWorkPostAction.onUpdateUid: _onUpdateUid,
    UserWorkPostAction.onRefreshFollowStatus: _onRefreshFollowStatus,
  });
}

void _onUpdateUid(Action action, Context<UserWorkPostState> ctx) async {
  RefreshModel refreshModel = action.payload;
  String uniqueId = refreshModel.uniqueId;
  if (uniqueId != ctx.state.uniqueId) {
    return;
  }
  if (ctx.state.uid == refreshModel.uid) {
    return;
  }
  ctx.dispatch(UserWorkPostActionCreator.initView());
  ctx.state.uid = refreshModel.uid;
  ctx.state.videoList.clear();
  ctx.state.pageNumber = 0;
  _onLoadData(action, ctx);
}

///点击进入
void _onTagItem(Action action, Context<UserWorkPostState> ctx) {
  String uniqueId = action.payload;
  int currentIndex =
      ctx.state.videoList.indexWhere((item) => uniqueId == item.uniqueId);
  if (currentIndex == null) {
    return;
  }
  Map<String, dynamic> map = Map();
  map['playType'] = VideoPlayConfig.VIDEO_TYPE_WORKS;
  map['currentPosition'] = currentIndex;
  map['pageNumber'] = ctx.state.pageNumber;
  map['uid'] = ctx.state.uid;
  map['pageSize'] = ctx.state.pageSize;
  map["apiAddress"] = Address.MINE_WORKS;
  map['videoList'] = ctx.state.videoList.map((it) => it.videoModel).toList();

  if (isHorizontalVideo(
      resolutionWidth(ctx.state.videoList[currentIndex].videoModel.resolution),
      resolutionHeight(ctx.state.videoList[currentIndex].videoModel.resolution))) {
    Gets.Get.to(VideoPage(ctx.state.videoList[currentIndex].videoModel),opaque: false);
  } else {
    Gets.Get.to(SubPlayListPage().buildPage(map), opaque: false);
  }

}

///加载数据
void _onLoadData(Action action, Context<UserWorkPostState> ctx) async {
  if (ctx.state.uid == null) {
    return;
  }
  if (ctx.state.requestStatus) {
    return;
  }
  ctx.state.requestStatus = true;
  // Map<String, dynamic> map = Map();
  // map['pageNumber'] = ctx.state.pageNumber + 1;
  // map['pageSize'] = ctx.state.pageSize;
  // map['uid'] = ctx.state.uid;
  int pageNumber = ctx.state.pageNumber + 1;
  int pageSize = ctx.state.pageSize;
  int uid = ctx.state.uid;
  try {
    ctx.state.requestStatus = false;
    ctx.state.loadComplete = true;
    MineVideo works =
        await netManager.client.getMineWorks(pageSize, pageNumber,"" , "SP", uid,);
    var postItemList = <WorkItemState>[];
    for (VideoModel videoModel in works.list) {
      WorkItemState workItemState = WorkItemState();
      workItemState.videoModel = videoModel;
      postItemList.add(workItemState);
    }
    ctx.state.hasNext = works.hasNext;
    ctx.state.pageNumber++;
    ctx.state.controller.finishLoad(noMore: !works.hasNext, success: true);
    ctx.dispatch(UserWorkPostActionCreator.loadDataSuccess(postItemList));
  } catch (e) {
    l.d('getMineWorks', e.toString());
    if (ctx.state.videoList.isEmpty) {
      ctx.dispatch(UserWorkPostActionCreator.loadDataFail());
    } else {
      ctx.state.controller.finishLoad(success: false);
    }
  }
}

void _onRefreshFollowStatus(Action action, Context<UserWorkPostState> ctx) {
  Map<String, dynamic> map = action.payload;
  int uid = map['uid'];
  for (var value in ctx.state.videoList) {
    if (value.videoModel.publisher.uid == uid &&
        value.videoModel.publisher.hasFollowed != map['isFollow']) {
      value.videoModel.publisher.hasFollowed = map['isFollow'];
    }
  }
}
