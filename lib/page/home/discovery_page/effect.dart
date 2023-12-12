import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/search/search_home_model.dart';
import 'package:flutter_app/page/search/hot_search_list/hot_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<DiscoveryState> buildEffect() {
  return combineEffects(<Object, Effect<DiscoveryState>>{
    Lifecycle.initState: _initState,
    DiscoveryAction.search: _onSearch,
    DiscoveryAction.onFindClick: _onFindClick,
    DiscoveryAction.onAreaClick: _onAreaClick,
    DiscoveryAction.loadData: _loadData,
    DiscoveryAction.loadMoreData: _loadMoreData,
  });
}

void _initState(Action action, Context<DiscoveryState> ctx) async {
  if (ctx.state.findList != null) {
    ctx.state.refreshController.refreshFailed();
  } else {
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
  }
  Future.delayed(Duration(milliseconds: 200), () {
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

void _loadData(Action action, Context<DiscoveryState> ctx) async {
  try {
    var areaModel = await netManager.client.getGoldCoinAreaList();
    ctx.dispatch(DiscoveryActionCreator.setAreaList(areaModel.list));
    var model =
        await netManager.client.getFindWonderfulList(1, ctx.state.pageSize);
    ctx.dispatch(DiscoveryActionCreator.setFindList(model.list));
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
  } catch (e) {
    l.d("getFindWonderfulList111", e.toString());
    ctx.state.refreshController.refreshFailed();
  }
}

void _loadMoreData(Action action, Context<DiscoveryState> ctx) async {
  try {
    var number = ctx.state.pageNumber + 1;
    var model = await netManager.client
        .getFindWonderfulList(number, ctx.state.pageSize);
    if (model.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
    ctx.dispatch(DiscoveryActionCreator.loadMoreFindData(model.list));
  } catch (e) {
    l.d("getFindWonderfulList", e.toString());
    ctx.state.refreshController.loadFailed();
  }
}

/// 标签点击
void _onFindClick(Action action, Context<DiscoveryState> ctx) {
  FindModel model = action.payload;
  var tagID = model.id;
  Map<String, dynamic> map = {'tagId': tagID};
  JRouter().go(PAGE_TAG, arguments: map);
}

void _onAreaClick(Action action, Context<DiscoveryState> ctx) {
  AreaModel item = action.payload;
  if (item.name == null) {
    return;
  }
  var _cell = ToneListBean();
  _cell.cover = item.cover;
  _cell.types = item.types;
  _cell.name = item.name;
  Map<String, dynamic> maps = {
    'searchBean': _cell,
    'theme': item.types,
  };
  JRouter().go(PAGE_HOT_LIST, arguments: maps);
}

void _onSearch(Action action, Context<DiscoveryState> ctx) {
  JRouter().go(PAGE_SPECIAL);
}
