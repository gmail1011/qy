import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'action.dart';
import 'state.dart';

Effect<VideoIncomeState> buildEffect() {
  return combineEffects(<Object, Effect<VideoIncomeState>>{
    VideoIncomeAction.loadData: _loadData,
    VideoIncomeAction.loadMoreData: _loadMoreData,
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<VideoIncomeState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () {
    _loadData(action, ctx);
  });
}

void _loadData(Action action, Context<VideoIncomeState> ctx) async {
  try {
    var model =
        await netManager.client.getVideoIncomeList(ctx.state.pageSize, 1);

    if ((model.videoIncomeList?.length ?? 0) == 0) {
      ctx.state.requestController.requestDataEmpty();
    } else {
      if (!model.hasNext) {
        ctx.state.refreshController.loadNoData();
      }
      ctx.state.requestController.requestSuccess();
    }
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    ctx.dispatch(VideoIncomeActionCreator.setLoadData(model));
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
    ctx.state.requestController.requestFail();
  }
}

void _loadMoreData(Action action, Context<VideoIncomeState> ctx) async {
  try {
    var number = ctx.state.pageNumber + 1;
    var model =
        await netManager.client.getVideoIncomeList(ctx.state.pageSize, number);
    if (model.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
    ctx.dispatch(
        VideoIncomeActionCreator.setLoadMoreData(model.videoIncomeList));
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
  }
}
