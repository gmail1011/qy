import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/widget/dialog/payfor_confirm_dialog.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'component/action.dart' as item;
import 'component/state.dart';
import 'state.dart';
import 'package:get/route_manager.dart' as Gets;

Effect<MineBuyPostState> buildEffect() {
  return combineEffects(<Object, Effect<MineBuyPostState>>{
    Lifecycle.initState: _onLoadData,
    MineBuyPostAction.onLoadData: _onLoadData,
    MineBuyPostAction.onDelBuyItem: _onDelBuyItem,
    item.MineBuyItemAction.onTapItem: _onTabItem,
  });
}

///加载数据
void _onLoadData(Action action, Context<MineBuyPostState> ctx) async {
  //滚动超过一屏幕的尺寸
  ctx.state.maxOutOffset =
      screen.screenHeight - screen.paddingBottom - screen.bottomNavBarH;

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
    MineVideo works = await netManager.client.getMineBuy(pageSize, pageNumber,  "SP", uid);
    ctx.state.pageNumber++;
    ctx.state.hasNext = works.hasNext;
    List<MineBuyItemState> list = [];
    MineBuyItemState buyItemState;
    works.list.forEach((item) {
      buyItemState = MineBuyItemState();
      buyItemState.videoModel = item;
      list.add(buyItemState);
    });
    ctx.dispatch(MineBuyPostActionCreator.loadDataSuccess(list));
  } catch (e) {
    l.d('getMineBuy', e.toString());
    if (ctx.state.videoList.isEmpty) {
      ctx.dispatch(MineBuyPostActionCreator.loadDataFail());
    }
  }
}

///点击ITEM
void _onTabItem(Action action, Context<MineBuyPostState> ctx) {
  String uniqueId = action.payload;
  int currentIndex =
      ctx.state.videoList.indexWhere((item) => uniqueId == item.uniqueId);
  if (currentIndex == null) {
    return;
  }
  Map<String, dynamic> map = Map();
  map['playType'] = VideoPlayConfig.VIDEO_TYPE_BUY;
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

///点击ITEM
void _onDelBuyItem(Action action, Context<MineBuyPostState> ctx) async {
  var item = action.payload as MineBuyItemState;
  var a = await showConfirmDialog(ctx.context, '是否确认删除该作品', Lang.DELETE,
      subTitle: "再次观看将要重新购买");
  if (a == Lang.DELETE) {
    try {
      await netManager.client.deleteBuyWork(item.videoModel.id);
      ctx.dispatch(MineBuyPostActionCreator.onDelRefresh(item));
      GlobalStore.updateUserInfo(null);
      showToast(msg: Lang.DELETE_SUC);
    } catch (e) {
      showToast(msg: Lang.DELETE_FAI);
    }
  }
}
