import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<VideoTopicState> buildEffect() {
  return combineEffects(<Object, Effect<VideoTopicState>>{
    Lifecycle.initState: _init,
    VideoTopicAction.tagClick: _onTagPage,
    VideoTopicAction.loadData: _onLoadData,
    VideoTopicAction.loadMoreData: _onLoadMoreData,
  });
}

///初始化数据
Future _init(Action action, Context<VideoTopicState> ctx) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    _onLoadData(action, ctx);
    //var list = await getAdsByType(AdsType.searchType);
    //ctx.dispatch(VideoTopicActionCreator.setAds(list ?? []));
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

///初始化数据
Future _onLoadData(Action action, Context<VideoTopicState> ctx) async {
  try {
    var specialModel = await netManager.client.getGroup(1, ctx.state.pageSize);
    ctx.dispatch(VideoTopicActionCreator.setLoadData(specialModel.list));
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    if ((specialModel?.list?.length ?? 0) == 0) {
      ctx.state.baseRequestController.requestDataEmpty();
    } else {
      ctx.state.baseRequestController.requestSuccess();
    }
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
    ctx.state.baseRequestController.requestFail();
    l.e("getGroup", e);
  }
}

///初始化数据
Future _onLoadMoreData(Action action, Context<VideoTopicState> ctx) async {
  try {
    var number = ctx.state.pageNumber + 1;
    var specialModel =
        await netManager.client.getGroup(number, ctx.state.pageSize);
    ctx.dispatch(VideoTopicActionCreator.setLoadMoreData(specialModel.list));
    if (specialModel.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
  } catch (e) {
    ctx.state.refreshController.loadFailed();
  }
}

///进入标签页
_onTagPage(Action action, Context<VideoTopicState> ctx) {
  var item = action.payload as ListBeanSp;
  Map<String, dynamic> maps = Map();
  maps['tagId'] = item.tagId;
  JRouter().go(PAGE_TAG, arguments: maps);
}
