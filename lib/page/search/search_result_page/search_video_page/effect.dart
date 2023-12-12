import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<SearchVideoState> buildEffect() {
  return combineEffects(<Object, Effect<SearchVideoState>>{
    SearchVideoAction.loadMoedData: _loadMoreData,
    SearchVideoAction.loadData: _loadData,
    SearchVideoAction.broadcastSearchAction: _broadcastSearchAction,
    Lifecycle.initState: _loadData,
  });
}

void _broadcastSearchAction(
    Action action, Context<SearchVideoState> ctx) async {
  var keywords = action.payload ?? '';
  ctx.state.keywords = keywords;
  ctx.dispatch(SearchVideoActionCreator.setKeywords(keywords));
  ctx.state.baseRequestController.requesting();
  ctx.dispatch(SearchVideoActionCreator.loadData());
}

void _loadData(Action action, Context<SearchVideoState> ctx) async {
  // ctx.state.refreshController.refreshCompleted();
  try {
    var model = await netManager.client
        .getVideoData(1, ctx.state.pageSize, [ctx.state.keywords], 'video');
    if ((model.list.length ?? 0) == 0) {
      ctx.state.baseRequestController.requestDataEmpty();
    } else {
      ctx.state.baseRequestController.requestSuccess();
    }

    if (!model.hasNext) {
      ctx.state.refreshController.loadNoData();
    }
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    ctx.dispatch(SearchVideoActionCreator.setLoadData(model.list));
  } catch (e) {
    ctx.state.baseRequestController.requestFail();
    ctx.state.refreshController.refreshFailed();
    l.d('getVideoData', e.toString());
  }
  
  // Future.delayed(Duration(milliseconds: 200),(){
  //   eaglePage(ctx.state.selfId(),
  //         sourceId: ctx.state.eagleId(ctx.context));
  // });
}

void _loadMoreData(Action action, Context<SearchVideoState> ctx) async {
  try {
    var number = ctx.state.pageNumber + 1;
    var model = await netManager.client.getVideoData(
        number, ctx.state.pageSize, [ctx.state.keywords], 'video');
    if (model.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
    ctx.dispatch(SearchVideoActionCreator.setLoadMoreData(model.list));
  } catch (e) {
    ctx.state.refreshController.loadFailed();
    l.d('getVideoData', e.toString());
  }
}
