import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/model/search/search_topic_model.dart';
import 'package:flutter_app/page/search/search_tag/search_tag_item/state.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/log.dart';
import '../../../common/net2/net_manager.dart';
import 'action.dart';
import 'state.dart';
import 'package:get/route_manager.dart' as Gets;

Effect<HotListState> buildEffect() {
  return combineEffects(<Object, Effect<HotListState>>{
    HotListAction.action: _onAction,
    Lifecycle.initState: _initState,
    HotListAction.onLoadMore: _onLoadMore,
    HotListAction.onclickVideo: _onclickVideo
  });
}

///初始化数据
Future<void> _initState(Action action, Context<HotListState> ctx) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    int pageNumber = ctx.state.pageNumber;
    String theme = ctx.state.theme ?? "";
    try {
      SearchTopicModel topModel =
          await netManager.client.loadSearchTopicData(pageNumber, 24, theme);
      ctx.dispatch(HotListActionCreator.onInitDataSuccess(topModel));
      ctx.state.requestComplete = true;
      ctx.state.headerRefreshController.loadComplete();
    } catch (e) {
      l.d('loadSearchTopicData', e.toString());
      ctx.state.requestComplete = true;
      ctx.state.headerRefreshController.loadComplete();
    }
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

void _onAction(Action action, Context<HotListState> ctx) {}

void _onclickVideo(Action action, Context<HotListState> ctx) {
  SearchTagItemState state = action.payload;
  Map<String, dynamic> map = Map();
  map["playType"] = VideoPlayConfig.VIDEO_TYPE_ZONE;
  map["currentPosition"] = ctx.state.items.indexOf(state);
  map["pageSize"] = 15;
  map["pageNumber"] = ctx.state.pageNumber;
  map['theme'] = ctx.state.theme ?? "";
  map['videoList'] = ctx.state.videoList;
  if (isHorizontalVideo(
      resolutionWidth(ctx.state.videoList[ctx.state.items.indexOf(state)].resolution),
      resolutionHeight(ctx.state.videoList[ctx.state.items.indexOf(state)].resolution))) {
    Gets.Get.to(() =>VideoPage(ctx.state.videoList[ctx.state.items.indexOf(state)]),opaque: false);
  } else {
    Gets.Get.to(() =>SubPlayListPage().buildPage(map), opaque: false);
  }
}

///加载更多
Future<void> _onLoadMore(Action action, Context<HotListState> ctx) async {
  // Map<String, dynamic> param = Map();
  // param['pageNumber'] = ctx.state.pageNumber;
  // param['pageSize'] = 24; //必须是6的倍数
  // param['theme'] = ctx.state.theme ?? "";
  int pageNumber = ctx.state.pageNumber;
  String theme = ctx.state.theme ?? "";
  try {
    SearchTopicModel topModel =
        await netManager.client.loadSearchTopicData(pageNumber, 24, theme);
    ctx.state.isShowLoading = false;
    // SearchTopicModel topModel = SearchTopicModel.fromMap(res.data);
    ctx.dispatch(HotListActionCreator.onInitDataSuccess(topModel));
    ctx.state.requestComplete = true;
    ctx.state.headerRefreshController.loadComplete();
  } catch (e) {
    l.d('loadSearchTopicData', e.toString());
    ctx.state.isShowLoading = false;
    ctx.state.requestComplete = true;
    ctx.state.headerRefreshController.loadComplete();
  }
  // BaseResponse res = await loadSearchTopicData(param);
  // if (res.code == 200) {
  //   ctx.state.isShowLoading = false;
  //   SearchTopicModel topModel = SearchTopicModel.fromMap(res.data);
  //   ctx.dispatch(HotListActionCreator.onInitDataSuccess(topModel));
  //   ctx.state.requestComplete = true;
  //   ctx.state.headerRefreshController.loadComplete();
  // } else {
  //   ctx.state.isShowLoading = false;
  //   ctx.state.requestComplete = true;
  //   ctx.state.headerRefreshController.loadComplete();
  // }
}
