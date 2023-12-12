import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/page/user/video_user_center/model/refresh_model.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'component/state.dart';
import 'state.dart';
import 'component/action.dart' as item;

import 'package:get/route_manager.dart' as Gets;

Effect<UserBuyPostState> buildEffect() {
  return combineEffects(<Object, Effect<UserBuyPostState>>{
    Lifecycle.initState: _onLoadData,
    UserBuyPostAction.onLoadData: _onLoadData,
    item.BuyItemAction.onTapItem: _onTabItem,
    UserBuyPostAction.onUpdateUid: _onUpdateUid,
    UserBuyPostAction.onRefreshFollowStatus: _onRefreshFollowStatus,
  });
}

void _onUpdateUid(Action action, Context<UserBuyPostState> ctx) async {
  RefreshModel refreshModel = action.payload;
  String uniqueId = refreshModel.uniqueId;
  if (uniqueId != ctx.state.uniqueId) {
    return;
  }
  if (ctx.state.uid == refreshModel.uid) {
    return;
  }
  ctx.state.uid = refreshModel.uid;
  ctx.state.videoList.clear();
  ctx.state.pageNumber = 0;
  _onLoadData(action, ctx);
}

///加载数据
void _onLoadData(Action action, Context<UserBuyPostState> ctx) async {
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
  // BaseResponse response = await getMineBuy(map);
  // ctx.state.requestStatus = false;
  // ctx.state.loadComplete = true;

  int pageNumber = ctx.state.pageNumber + 1;
  int pageSize = ctx.state.pageSize;
  int uid = ctx.state.uid;
  ctx.state.requestStatus = false;
  ctx.state.loadComplete = true;
  try {
    MineVideo works = await netManager.client.getMineBuy(pageSize, pageNumber, "SP", uid);
    ctx.state.pageNumber++;
    ctx.state.hasNext = works.hasNext;
    List<BuyItemState> list = [];
    BuyItemState buyItemState;
    works.list.forEach((item) {
      buyItemState = BuyItemState();
      buyItemState.videoModel = item;
      list.add(buyItemState);
    });
    ctx.dispatch(UserBuyPostActionCreator.loadDataSuccess(list));
  } catch (e) {
    l.d('getMineBuy', e.toString());
    if (ctx.state.videoList.isEmpty) {
      ctx.dispatch(UserBuyPostActionCreator.loadDataFail());
    }
  }
  // if (response.code == Code.SUCCESS) {
  //   MineVideo works = MineVideo.fromJson(response.data);
  //   ctx.state.pageNumber++;
  //   ctx.state.hasNext = works.hasNext;
  //   List<BuyItemState> list = [];
  //   BuyItemState buyItemState;
  //   works.list.forEach((item) {
  //     buyItemState = BuyItemState();
  //     buyItemState.videoModel = item;
  //     list.add(buyItemState);
  //   });
  //   ctx.dispatch(UserBuyPostActionCreator.loadDataSuccess(list));
  // } else {
  //   if (ctx.state.videoList.isEmpty) {
  //     ctx.dispatch(UserBuyPostActionCreator.loadDataFail());
  //   }
  // }
}

///点击ITEM
void _onTabItem(Action action, Context<UserBuyPostState> ctx) {
  String uniqueId = action.payload;
  Map<String, dynamic> map = Map();
  map['playType'] = VideoPlayConfig.VIDEO_TYPE_BUY;
  map['currentPosition'] =
      ctx.state.videoList.indexWhere((item) => uniqueId == item.uniqueId);
  map['pageNumber'] = ctx.state.pageNumber;
  map['uid'] = ctx.state.uid;
  map['pageSize'] = ctx.state.pageSize;
  map["apiAddress"] = Address.MINE_WORKS;
  map['videoList'] = ctx.state.videoList.map((it) => it.videoModel).toList();

  if (isHorizontalVideo(
      resolutionWidth(ctx.state.videoList[ctx.state.videoList.indexWhere((item) => uniqueId == item.uniqueId)].videoModel.resolution),
      resolutionHeight(ctx.state.videoList[ctx.state.videoList.indexWhere((item) => uniqueId == item.uniqueId)].videoModel.resolution))) {
    Gets.Get.to(() =>VideoPage(ctx.state.videoList[ctx.state.videoList.indexWhere((item) => uniqueId == item.uniqueId)].videoModel),opaque: false);
  } else {
    Gets.Get.to(SubPlayListPage().buildPage(map), opaque: false);
  }
}

void _onRefreshFollowStatus(Action action, Context<UserBuyPostState> ctx) {
  Map<String, dynamic> map = action.payload;
  int uid = map['uid'];
  for (var value in ctx.state.videoList) {
    if (value.videoModel.publisher.uid == uid &&
        value.videoModel.publisher.hasFollowed != map['isFollow']) {
      value.videoModel.publisher.hasFollowed = map['isFollow'];
    }
  }
}
