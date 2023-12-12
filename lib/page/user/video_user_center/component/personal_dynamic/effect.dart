import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/selected_tags_entity.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/post/post_item_component/action.dart';
import 'package:flutter_app/page/home/post/post_item_component/post_item_widget.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_app/page/user/video_user_center/model/refresh_model.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';
import 'package:get/route_manager.dart' as Gets;

Effect<UserDynamicPostState> buildEffect() {
  return combineEffects(<Object, Effect<UserDynamicPostState>>{
    Lifecycle.initState: _onLoadData,
    PostItemAction.tellFatherJumpPage: _onJumpToVideoPlayList,
    UserDynamicPostAction.onLoadData: _onLoadData,
    UserDynamicPostAction.onUpdateUid: _onUpdateUid,
    UserDynamicPostAction.onRefreshFollowStatus: _onRefreshFollowStatus,
  });
}

void _onUpdateUid(Action action, Context<UserDynamicPostState> ctx) async {
  RefreshModel refreshModel = action.payload;
  String uniqueId = refreshModel.uniqueId;
  if (uniqueId != ctx.state.uniqueId) {
    return;
  }
  if (ctx.state.uid == refreshModel.uid) {
    return;
  }
  ctx.dispatch(UserDynamicPostActionCreator.initView());
  ctx.state.uid = refreshModel.uid;
  ctx.state.videoList.clear();
  ctx.state.pageNumber = 0;
  _onLoadData(action, ctx);
}

///点击进入
void _onJumpToVideoPlayList(Action action, Context<UserDynamicPostState> ctx) {
  l.i("post", "_onJumpToVideoPlayList()...UC");
  PostItemState itemState = action.payload;

  Map<String, dynamic> map = Map();
  map['playType'] = VideoPlayConfig.VIDEO_TYPE_WORKS;
  map['pageNumber'] = ctx.state.pageNumber;
  map['uid'] = ctx.state.uid;
  map['pageSize'] = ctx.state.pageSize;
  map["apiAddress"] = Address.MINE_WORKS;
  map['currentPosition'] =
      ctx.state.videoList.indexWhere((it) => it.uniqueId == itemState.uniqueId);
  map['videoList'] = ctx.state.videoList.map((it) => it.videoModel).toList();

  if (isHorizontalVideo(
      resolutionWidth(ctx.state.videoList[ctx.state.videoList.indexWhere((it) => it.uniqueId == itemState.uniqueId)].videoModel.resolution),
      resolutionHeight(ctx.state.videoList[ctx.state.videoList.indexWhere((it) => it.uniqueId == itemState.uniqueId)].videoModel.resolution))) {
    Gets.Get.to(VideoPage(ctx.state.videoList[ctx.state.videoList.indexWhere((it) => it.uniqueId == itemState.uniqueId)].videoModel),opaque: false);
  } else {
    Gets.Get.to(SubPlayListPage().buildPage(map), opaque: false);
  }
}

///加载数据
void _onLoadData(Action action, Context<UserDynamicPostState> ctx) async {
  if (ctx.state.uid == null) {
    return;
  }
  if (ctx.state.requestStatus) {
    return;
  }
  ctx.state.requestStatus = true;
  int pageNumber = ctx.state.pageNumber + 1;
  int pageSize = ctx.state.pageSize;
  int uid = ctx.state.uid;
  try {
    ctx.state.requestStatus = false;
    ctx.state.loadComplete = true;
    //MineVideo works = await netManager.client.getMineWorks(pageSize, pageNumber, uid);
    SelectedTagsData selectedTagsData = await netManager.client.getSquareListDetail(3,9,pageNumber, pageSize, ctx.state.uid);
    var postItemList = <PostItemState>[];
    /*for (VideoModel videoModel in works.list) {
      PostItemState itemState = PostItemState(videoModel: videoModel, postFrom: PostFrom.UC);
      itemState.isShowFullButton = videoModel.title.length > itemState.maxLength;
      // itemState.isNeedPay = needBuyVideo(videoModel);
      postItemList.add(itemState);
    }*/

    selectedTagsData.xList.forEach((element) {
      VideoModel videoModel = VideoModel.fromJson(element.toJson());
      PostItemState itemState = PostItemState(videoModel: videoModel, postFrom: PostFrom.UC);
      itemState.isShowFullButton = videoModel.title.length > itemState.maxLength;
      // itemState.isNeedPay = needBuyVideo(videoModel);
      postItemList.add(itemState);
    });

    ctx.state.hasNext = selectedTagsData.hasNext;
    ctx.state.pageNumber++;
    ctx.state.controller.finishLoad(noMore: !selectedTagsData.hasNext, success: true);
    ctx.dispatch(UserDynamicPostActionCreator.loadDataSuccess(postItemList));
  } catch (e) {
    l.d('getMineWorks', e.toString());
    if (ctx.state.videoList.isEmpty) {
      ctx.dispatch(UserDynamicPostActionCreator.loadDataFail());
    } else {
      ctx.state.controller.finishLoad(success: false);
    }
  }
  // var res = await getMineWorks(map);
  // ctx.state.requestStatus = false;
  // ctx.state.loadComplete = true;
  // if (res.code == 200) {
  //   MineVideo works = MineVideo.fromMap(res.data);
  //   var postItemList = <DynamicItemState>[];
  //   for (VideoModel videoModel in works.list) {
  //     DynamicItemState itemState = DynamicItemState();
  //     itemState.videoModel = videoModel;

  //     itemState.itemType = ItemType.IMAGE;
  //     if (videoModel.isVideo()) {
  //       itemState.itemType = ItemType.VIDEO;
  //     }
  //     itemState.isShowFullButton =
  //         videoModel.title.length > itemState.maxLength;
  //     if (videoModel.coins != 0 &&
  //         !GlobalStore.isMe(videoModel.publisher.uid) &&
  //         !videoModel.vidStatus.hasPaid &&
  //         !(videoModel.freeArea ?? false)) {
  //       itemState.isNeedPay = true;
  //     }

  //     videoModel.tags?.forEach((item) {
  //       if (itemState.tagsStr.length < (itemState.isNeedPay ? 2 : 3)) {
  //         itemState.tagsStr.add(item.name);
  //       }
  //     });

  //     postItemList.add(itemState);
  //   }
  //   ctx.state.hasNext = works.hasNext;
  //   ctx.state.pageNumber++;
  //   ctx.state.controller.finishLoad(noMore: !works.hasNext, success: true);
  //   ctx.dispatch(UserDynamicPostActionCreator.loadDataSuccess(postItemList));
  // } else {
  //   if (ctx.state.videoList.isEmpty) {
  //     ctx.dispatch(UserDynamicPostActionCreator.loadDataFail());
  //   } else {
  //     ctx.state.controller.finishLoad(success: false);
  //   }
  // }
}

void _onRefreshFollowStatus(Action action, Context<UserDynamicPostState> ctx) {
  Map<String, dynamic> map = action.payload;
  bool isUpdate = false;
  int uid = map['uid'];
  for (var value in ctx.state.videoList) {
    if (value.videoModel.publisher.uid == uid &&
        value.videoModel.publisher.hasFollowed != map['isFollow']) {
      value.videoModel.publisher.hasFollowed = map['isFollow'];
      isUpdate = true;
    }
  }
  if (isUpdate) {
    ctx.dispatch(UserDynamicPostActionCreator.refreshFollowStatus());
  }
}
