import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/page/city/nearby/action.dart';
import 'package:flutter_app/page/video/main_play_list/action.dart';
import 'package:flutter_app/page/video/player_manager.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/page/home/post/page/common_post/action.dart';
import 'package:flutter_app/page/user/video_user_center/action.dart';
import 'package:flutter_app/common/manager/event_manager.dart';
import 'package:flutter_app/utils/global_variable.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'action.dart';
import 'state.dart';

Effect<PostItemState> buildEffect() {
  return combineEffects(<Object, Effect<PostItemState>>{
    PostItemAction.onPicTap: _onPicTap,
    PostItemAction.onLike: _onLike,
    PostItemAction.onCommend: _onCommend,
    PostItemAction.onShare: _onShare,
    PostItemAction.onFollow: _onFollow,
    PostItemAction.onTag: _onTag,
    PostItemAction.onCollect: _onCollect,
    PostItemAction.onClickItem: _onClickItem,
    PostItemAction.onBuyVideo: _onBuyProduct,
  });
}

void _onPicTap(Action action, Context<PostItemState> ctx) {
  Map<String, dynamic> map = action.payload;
  final PostItemState itemState = map["state"];
  if (ctx.state.uniqueId == itemState.uniqueId) {
    var index = map["index"];
    showPictureSwipe(ctx.context, ctx.state.type == "3" ? ctx.state.newVideoModel[0].seriesCover : ctx.state.videoModel.seriesCover, index,
        imageTyp: ImageTyp.NET);
  }
}

void _onFollow(Action action, Context<PostItemState> ctx) async {
  if (action.payload != ctx.state.uniqueId) {
    return;
  }
  // 自己不能关注自己
  if (GlobalStore.isMe(ctx.state.type == "3" ? ctx.state.newVideoModel[0].publisher.uid  : ctx.state.videoModel.publisher.uid)) {
    showToast(msg: Lang.GLOBAL_TIP_TXT1);
    return;
  }
  bool isFollow = !(ctx.state.type == "3" ? ctx.state.newVideoModel[0].publisher.hasFollowed : ctx.state.videoModel.publisher.hasFollowed);
  //refresh current item
  if(ctx.state.type == "3"){
    ctx.state.newVideoModel[0].publisher.hasFollowed = isFollow;
    ctx.state.isShowPopoverUnFollowBtn = isFollow;
  }else{
    ctx.state.videoModel.publisher.hasFollowed = isFollow;
    ctx.state.isShowPopoverUnFollowBtn = isFollow;
  }

  ctx.dispatch(PostItemActionCreator.followSuccess(ctx.state.uniqueId));

  int followUID = ctx.state.type == "3" ? ctx.state.newVideoModel[0].publisher.uid  : ctx.state.videoModel.publisher.uid;
  try {
    await netManager.client.getFollow(followUID, isFollow);

    ///刷新其它界面的状态
    Map<String, dynamic> map = Map<String, dynamic>();
    map["uid"] = ctx.state.type == "3" ? ctx.state.newVideoModel[0].publisher.uid  :  ctx.state.videoModel.publisher.uid;
    map["isFollow"] = isFollow;
    ctx.broadcast(MainPlayerListActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(NearbyActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(CommonPostActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(VideoUserCenterActionCreator.onRefreshFollowStatus(map));
  } catch (e) {
    l.d('getFollow', e.toString());
    showToast(msg: Lang.FOLLOW_ERROR, gravity: ToastGravity.CENTER);
  }
}

void _onTag(Action action, Context<PostItemState> ctx) async {
  ///先暂停视频
  // dispatch(PlayListItemActionCreator.releasePlayer());
  Map<String, dynamic> map = action.payload;
  final PostItemState itemState = map["state"];
  if (ctx.state.uniqueId == itemState.uniqueId) {
    var index = map["index"];
    GlobalVariable.eventBus.fire(LoadOriginEvent(3));
    Map<String, dynamic> parameter = Map();
    parameter['tagId'] = ctx.state.type == "3" ? ctx.state.newVideoModel[0].tags[index].id  :  ctx.state.videoModel.tags[index].id;
    autoPlayModel.disposeAll();
    await JRouter().go(PAGE_TAG, arguments: parameter);
    autoPlayModel.startAvailblePlayer();
  }
}

void _onLike(Action action, Context<PostItemState> ctx) async {
  Map likeMap = action.payload;
  var uniqueId = likeMap["uniqueId"];
  if (uniqueId != ctx.state.uniqueId) {
    return;
  }
  var status = likeMap["like"];
  String objID = ctx.state.type == "3" ? ctx.state.newVideoModel[0].id : ctx.state.videoModel.id;
  String type = 'video';

  try {
    if (!status) {
      await netManager.client.cancelLike(objID, type);
    } else {
      await netManager.client.sendLike(objID, type);
    }
    if(ctx.state.type == "3"){
      ctx.state.newVideoModel[0].vidStatus.hasLiked = status;
    }else{
      ctx.state.videoModel.vidStatus.hasLiked = status;
    }
    if (!status) {
      if(ctx.state.type == "3"){
        ctx.state.newVideoModel[0].likeCount -= 1;
      }else{
        ctx.state.videoModel.likeCount -= 1;
      }

    } else {
      if(ctx.state.type == "3"){
        ctx.state.newVideoModel[0].likeCount += 1;
      }else{
        ctx.state.videoModel.likeCount += 1;
      }

    }
  } catch (e) {
    l.d('cancelLike/sendLike', e.toString());
    showToast(msg: e.toString());
  }
}

void _onCommend(Action action, Context<PostItemState> ctx) {
  final String uniqueId = action.payload;
  if (ctx.state.uniqueId == uniqueId) {
    if ((ctx.state.type == "3" ? ctx.state.newVideoModel[0].status : ctx.state.videoModel.status) != 1 && ((ctx.state.type == "3" ? ctx.state.newVideoModel[0].status : ctx.state.videoModel.status)) != 3) {
      //0 未审核 1通过 2审核失败 3视为免费 默认为0
      showToast(msg: Lang.GLOBAL_TIP_TXT2, gravity: ToastGravity.CENTER);
      return;
    }
    showCommentDialog(
      context: ctx.context,
      id: ctx.state.type == "3" ? ctx.state.newVideoModel[0].id : ctx.state.videoModel.id,
      index: 1,
      province: ctx.state.type == "3" ? ctx.state.newVideoModel[0]?.location?.province ?? ""  : ctx.state.videoModel?.location?.province ?? "",
      city: ctx.state.type == "3" ? ctx.state.newVideoModel[0]?.location?.city ?? ""  : ctx.state.videoModel?.location?.city ?? "",
      visitNum: "${ctx.state.type == "3" ? ctx.state.newVideoModel[0]?.location?.visit ?? 0 : ctx.state.videoModel?.location?.visit ?? 0}",
      callback: (Map<String, dynamic> map) {
//        safePopPage();
        ctx.dispatch(PostItemActionCreator.commentSuccess(ctx.state.uniqueId));
      },
    );
  }
}

void _onShare(Action action, Context<PostItemState> ctx) async {
  showShareVideoDialog(
    ctx.context,
    () {},
  );
}

_onCollect(Action action, Context<PostItemState> ctx) async {
  final PostItemState itemState = action.payload;
  if (ctx.state.uniqueId == itemState.uniqueId) {
    String type = 'video';
    String objID = ctx.state.type == "3" ? ctx.state.newVideoModel[0].id : ctx.state.videoModel.id;
    bool isCollect = !(ctx.state.type == "3" ?  ctx.state.newVideoModel[0].vidStatus.hasCollected : ctx.state.videoModel.vidStatus.hasCollected);
    try {
      await netManager.client.changeTagStatus(objID, isCollect, type);
      if (!(ctx.state.type == "3" ?  ctx.state.newVideoModel[0].vidStatus.hasCollected : ctx.state.videoModel.vidStatus.hasCollected)) {
        showToast(msg: Lang.COLLECTION_SUCCESS, gravity: ToastGravity.CENTER);
      }
      ctx.dispatch(PostItemActionCreator.changeCollectSuccess(action.payload));
    } catch (e) {
      l.d('changeTagStatus', e.toString());
      if (ctx.context == null) return;
      showToast(msg: e.toString());
    }
  }
}

void _onClickItem(Action action, Context<PostItemState> ctx) {
  l.i("test", "onItemClick()...post");
  if (ctx.state.uniqueId == action.payload) {
    ctx.dispatch(PostItemActionCreator.tellFatherJumpPage(ctx.state));
  }
}

bool isBeforeToday(){
  var startDate = GlobalStore.getMe().goldVideoFreeExpire;
  var endDate = new DateTime.now();
  return DateTime.parse(startDate).isBefore(endDate);
}

///弹出购买提示框
_onBuyProduct(Action action, Context<PostItemState> ctx) async {
  l.i("post Effect", "_onBuyProduct()...");


  ///购买vip后10金币以下免费
  /*var result;
  if(ctx.state.videoModel.coins <= 10 && !isBeforeToday()){
    result = true;
  }else{
    //购买视频
    result = await showBuyVideo(ctx.context, ctx.state.videoModel);
  }*/


  ///购买视频
  var result = await showBuyVideo(ctx.context, ctx.state.type == "3" ?  ctx.state.newVideoModel : ctx.state.videoModel);

  ///true表示支付成功
  if (result != null && result) {
    ctx.dispatch(PostItemActionCreator.onBuyVideoSuccess(ctx.state.uniqueId));
    if (ctx.state.type == "3" ? ctx.state.newVideoModel[0].isVideo() : ctx.state.videoModel.isVideo()) {
      // 支付成功控制播放
      autoPlayModel.startAvailblePlayer();
    }
  }
}
