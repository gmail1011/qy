import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_like/component/action.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_like/state.dart';
import 'package:flutter_app/page/user/video_user_center/model/refresh_model.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'component/state.dart';
import 'package:get/route_manager.dart' as Gets;

Effect<UserLikePostState> buildEffect() {
  return combineEffects(<Object, Effect<UserLikePostState>>{
    Lifecycle.initState: _onLoadData,
    UserLikePostAction.onLoadData: _onLoadData,
    LikeItemAction.onTapItem: _onTapItem,
    UserLikePostAction.onUpdateUid: _onUpdateUid,
    UserLikePostAction.onRefreshFollowStatus: _onRefreshFollowStatus,
  });
}

void _onUpdateUid(Action action, Context<UserLikePostState> ctx) async {
  RefreshModel refreshModel = action.payload;
  String uniqueId = refreshModel.uniqueId;
  if (uniqueId != ctx.state.uniqueId) {
    return;
  }
  if (ctx.state.uid == refreshModel.uid) {
    return;
  }
  ctx.dispatch(UserLikePostActionCreator.initView());
  ctx.state.uid = refreshModel.uid;
  ctx.state.videoList.clear();
  ctx.state.pageNumber = 0;
  _onLoadData(action, ctx);
}

///进入二级播放界面
void _onTapItem(Action action, Context<UserLikePostState> ctx) async {
  String uniqueId = action.payload;
  int currentIndex =
      ctx.state.videoList.indexWhere((item) => uniqueId == item.uniqueId);
  if (currentIndex == null) {
    return;
  }
  Map<String, dynamic> map = Map();
  map['playType'] = VideoPlayConfig.VIDEO_TYPE_ENDORSE;
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

void _onLoadData(Action action, Context<UserLikePostState> ctx) async {
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
  // BaseResponse response = await getMineLike(map);
  // ctx.state.requestStatus = false;
  // ctx.state.loadComplete = true;

  int pageNumber = ctx.state.pageNumber + 1;
  int pageSize = ctx.state.pageSize;
  int uid = ctx.state.uid;
  ctx.state.requestStatus = false;
  ctx.state.loadComplete = true;
  try {
    MineVideo works =
        await netManager.client.getMineLike(pageSize, pageNumber, uid);
    List<LikeItemState> list = [];
    works.list.forEach((item) {
      list.add(LikeItemState()..videoModel = item);
    });
    ctx.state.pageNumber++;
    ctx.state.hasNext = works.hasNext;
    ctx.state.controller.finishLoad(success: false, noMore: ctx.state.hasNext);
    ctx.dispatch(UserLikePostActionCreator.loadDataSuccess(list));
  } catch (e) {
    l.d('getMineLike', e.toString());
    ctx.state.controller.finishLoad(success: false);
    if (ctx.state.videoList.isEmpty) {
      ctx.dispatch(UserLikePostActionCreator.loadDataFail());
    }
  }
  // if (response.code == 200) {
  //   MineVideo works = MineVideo.fromJson(response.data);
  //   List<LikeItemState> list = [];
  //   works.list.forEach((item) {
  //     list.add(LikeItemState()..videoModel = item);
  //   });
  //   ctx.state.pageNumber++;
  //   ctx.state.hasNext = works.hasNext;
  //   ctx.state.controller.finishLoad(success: false, noMore: ctx.state.hasNext);
  //   ctx.dispatch(UserLikePostActionCreator.loadDataSuccess(list));
  // } else {
  //   ctx.state.controller.finishLoad(success: false);
  //   if (ctx.state.videoList.isEmpty) {
  //     ctx.dispatch(UserLikePostActionCreator.loadDataFail());
  //   }
  // }
}

void _onRefreshFollowStatus(Action action, Context<UserLikePostState> ctx) {
  Map<String, dynamic> map = action.payload;
  int uid = map['uid'];
  for (var value in ctx.state.videoList) {
    if (value.videoModel.publisher.uid == uid &&
        value.videoModel.publisher.hasFollowed != map['isFollow']) {
      value.videoModel.publisher.hasFollowed = map['isFollow'];
    }
  }
}
