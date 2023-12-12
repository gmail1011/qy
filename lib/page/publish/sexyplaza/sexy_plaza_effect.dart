import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/selected_tags_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/post/post_item_component/action.dart';
import 'package:flutter_app/page/home/post/post_item_component/post_item_widget.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:get/route_manager.dart' as Gets;
import 'sexy_plaza_action.dart';
import 'sexy_plaza_state.dart';

Effect<SexyPlazaState> buildEffect() {
  return combineEffects(<Object, Effect<SexyPlazaState>>{
    SexyPlazaAction.action: _onAction,
    Lifecycle.initState: _onInitData,
    PostItemAction.tellFatherJumpPage: _onJumpToVideoPlayList,
    SexyPlazaAction.onLoadMore: _onLoadMore,
  });
}

void _onAction(Action action, Context<SexyPlazaState> ctx) {

}

void _onInitData(Action action, Context<SexyPlazaState> ctx) async{
 // var list = await getAdsByType(AdsType.hotType);
  //ctx.dispatch(SexyPlazaActionCreator.getAdsSuccess(list ?? []));

  SelectedTagsData selectedTagsData = await netManager.client.getSquareListDetail(3,9,ctx.state.pageNum, ctx.state.pageSize, 0);

  var postItemList = <PostItemState>[];


  selectedTagsData.xList.forEach((element) {
    VideoModel videoModel = VideoModel.fromJson(element.toJson());
    PostItemState itemState = PostItemState(videoModel: videoModel, postFrom: PostFrom.UC);
    itemState.isShowFullButton = videoModel.title.length > itemState.maxLength;
    // itemState.isNeedPay = needBuyVideo(videoModel);
    postItemList.add(itemState);
  });

  ctx.state.hasNext = selectedTagsData.hasNext;
  ctx.state.controller.finishLoad(noMore: !selectedTagsData.hasNext, success: true);
  ctx.dispatch(SexyPlazaActionCreator.loadDataSuccess(postItemList));
}

void _onJumpToVideoPlayList(Action action, Context<SexyPlazaState> ctx) {
  l.i("post", "_onJumpToVideoPlayList()...UC");
  PostItemState itemState = action.payload;

  Map<String, dynamic> map = Map();
  map['playType'] = VideoPlayConfig.VIDEO_TYPE_WORKS;
  map['pageNumber'] = ctx.state.pageNum;
  map['uid'] = itemState.videoModel.publisher.uid;
  map['pageSize'] = ctx.state.pageSize;
  map["apiAddress"] = Address.MINE_WORKS;
  map['currentPosition'] = ctx.state.videoList.indexWhere((it) => it.uniqueId == itemState.uniqueId);
  map['videoList'] = ctx.state.videoList.map((it) => it.videoModel).toList();


  if (isHorizontalVideo(
      resolutionWidth(ctx.state.videoList[ctx.state.videoList.indexWhere((it) => it.uniqueId == itemState.uniqueId)].videoModel.resolution),
      resolutionHeight(ctx.state.videoList[ctx.state.videoList.indexWhere((it) => it.uniqueId == itemState.uniqueId)].videoModel.resolution))) {
    Gets.Get.to(() =>VideoPage(ctx.state.videoList[ctx.state.videoList.indexWhere((it) => it.uniqueId == itemState.uniqueId)].videoModel),opaque: false);
  } else {
    Gets.Get.to(() =>SubPlayListPage().buildPage(map), opaque: false);
  }
}

void _onLoadMore(Action action, Context<SexyPlazaState> ctx) async{
  SelectedTagsData selectedTagsData = await netManager.client.getSquareListDetail(3,9,action.payload, ctx.state.pageSize, 0);

  var postItemList = <PostItemState>[];


  selectedTagsData.xList.forEach((element) {
    VideoModel videoModel = VideoModel.fromJson(element.toJson());
    PostItemState itemState = PostItemState(videoModel: videoModel, postFrom: PostFrom.UC);
    itemState.isShowFullButton = videoModel.title.length > itemState.maxLength;
    // itemState.isNeedPay = needBuyVideo(videoModel);
    postItemList.add(itemState);
  });

  ctx.state.hasNext = selectedTagsData.hasNext;
  ctx.state.controller.finishLoad(noMore: !selectedTagsData.hasNext, success: true);
  ctx.dispatch(SexyPlazaActionCreator.loadDataSuccess(postItemList));
}
