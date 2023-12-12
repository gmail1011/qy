import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/home/post/post_item_component/post_item_widget.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:get/route_manager.dart' as Gets;
import 'action.dart';
import 'state.dart';

Effect<MineWorkState> buildEffect() {
  return combineEffects(<Object, Effect<MineWorkState>>{
    MineWorkAction.onLoadWork: _onLoadWork,
    Lifecycle.initState: _init,
    MineWorkAction.onItemClick: _onItemClick,
    MineWorkAction.delWorkItem: _delWorkItem,
    MineWorkAction.getWorkData: _onGetWorkData,
    MineWorkAction.refreshItem: _onRefreshItem,
  });
}

void _onGetWorkData(Action action, Context<MineWorkState> ctx) async {
  ctx.state.pageNumber = 1;
  int pageNumber = ctx.state.pageNumber;
  int pageSize = ctx.state.pageSize;
  try {
    MineVideo works =
        await netManager.client.getMineWorks(pageSize, pageNumber,"","SP");
    ctx.state.isLoading = false;
    if (!works.hasNext) {
      ctx.state.workController.finishLoad(noMore: true, success: true);
    } else {
      ctx.state.workController.finishLoad(success: true);
    }
    ctx.state.workVideo = works;
    ctx.state.workStateList.clear();
    ctx.state.workStateList.addAll(_initData(works));
    ctx.dispatch(MineWorkActionCreator.onRefreshWork(works));
  } catch (e) {
    l.d('getMineWorks=', e.toString());
    ctx.state.workController.finishLoad(success: false);
  }
}

List<PostItemState> _initData(MineVideo workVideo) {
  List<PostItemState> workStateList = [];
  for (int i = 0; i < workVideo?.list?.length ?? 0; i++) {
    VideoModel videoModel = workVideo?.list[i];
    PostItemState itemState =
        PostItemState(videoModel: videoModel, postFrom: PostFrom.MINE);
    itemState.isShowFullButton = videoModel.title.length > itemState.maxLength;
    workStateList.add(itemState);
  }
  return workStateList;
}

void _init(Action action, Context<MineWorkState> ctx) async {
  ctx.state.pageNumber = 1;
  //滚动超过一屏幕的尺寸
  ctx.state.maxOutOffset =
      screen.designH - screen.paddingBottom - screen.bottomNavBarH;
  _onGetWorkData(action, ctx);
}

void _onLoadWork(Action action, Context<MineWorkState> ctx) async {
  int pageNumber = ctx.state.pageNumber + 1;
  int pageSize = ctx.state.pageSize;

  try {
    MineVideo works =
        await netManager.client.getMineWorks(pageSize, pageNumber,"","SP");
    if (!works.hasNext) {
      ctx.state.workController.finishLoad(noMore: true, success: true);
    } else {
      ctx.state.pageNumber++;
      ctx.state.workController.finishLoad(success: true);
    }
    ctx.state.workVideo.list.addAll(works.list);
    ctx.state.workVideo.hasNext = works.hasNext;
    ctx.state.workStateList.addAll(_initData(works));
    ctx.dispatch(MineWorkActionCreator.onRefreshWork(works));
  } catch (e) {
    l.d('getMineWorks=', e.toString());
    ctx.state.workController.finishLoad(success: false);
  }
}

void _onItemClick(Action action, Context<MineWorkState> ctx) async {
  PostItemState itemState = action.payload;
  Map<String, dynamic> param = Map();
  param["city"] = itemState.videoModel.location.city;
  param["ip"] = "192.168.1.159";
  param["pageSize"] = ctx.state.workStateList.length;
  param["pageNumber"] = ctx.state.pageNumber;
  param["playType"] = VideoPlayConfig.VIDEO_TYPE_WORKS;
  param["apiAddress"] = Address.SAME_CITY_LIST;
  param["currentPosition"] = ctx.state.workStateList
      .indexWhere((it) => it.uniqueId == itemState.uniqueId);
  param['videoList'] =
      ctx.state.workStateList.map((it) => it.videoModel).toList();



  if (isHorizontalVideo(
      resolutionWidth(ctx.state.workStateList[ctx.state.workStateList
          .indexWhere((it) => it.uniqueId == itemState.uniqueId)].videoModel.resolution),
      resolutionHeight(ctx.state.workStateList[ctx.state.workStateList
          .indexWhere((it) => it.uniqueId == itemState.uniqueId)].videoModel.resolution))) {
    Gets.Get.to(VideoPage(ctx.state.workStateList[ctx.state.workStateList
        .indexWhere((it) => it.uniqueId == itemState.uniqueId)].videoModel),opaque: false);
  } else {
    Gets.Get.to(SubPlayListPage().buildPage(param), opaque: false);
  }

}

///点击删除自己作品
Future<void> _delWorkItem(Action action, Context<MineWorkState> ctx) async {
  VideoModel videoModel = action.payload;
  // Map<String, dynamic> map = Map();
  List<String> idList = List();
  idList.add(videoModel.id);
  // map['ids'] = idList;
  // BaseResponse res = await HttpManager().post(Address.DEL_WORK, params: map);
  try {
    await netManager.client.postDelWork(idList);
    //删除成功，重新刷新页面
    videoModel.isWantDel = false;
    GlobalStore.updateUserInfo(null);
    showToast(msg: "删除成功");
    ctx.broadcast(MineWorkActionCreator.onRefreshItem(ctx.state.pageType));
    _init(action, ctx);
  } catch (e) {
    //showToast(msg: e.toString());
    videoModel.isWantDel = false;
    l.e('postDelWork', e.toString());
  }
}

void _onRefreshItem(Action action, Context<MineWorkState> ctx) {
  var type = action.payload as MineWorkPageType;
  if (type != ctx.state.pageType) {
    _init(action, ctx);
  }
}
