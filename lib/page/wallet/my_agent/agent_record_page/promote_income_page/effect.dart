import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'action.dart';
import 'state.dart';

Effect<PromoteIncomeState> buildEffect() {
  return combineEffects(<Object, Effect<PromoteIncomeState>>{
    PromoteIncomeAction.loadData: _loadData,
    PromoteIncomeAction.loadMoreData: _loadMoreData,
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<PromoteIncomeState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () {
    _loadData(action, ctx);
  });
}

void _loadData(Action action, Context<PromoteIncomeState> ctx) async {
  try {
    var model =
        await netManager.client.getInviteIncomeList(ctx.state.pageSize, 1);
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);

    if ((model?.inviteItemList?.length ?? 0) == 0) {
      ctx.state.requestController.requestDataEmpty();
    } else {
      if (!model.hasNext) {
        ctx.state.refreshController.loadNoData();
      }
      ctx.state.requestController.requestSuccess();
    }
    ctx.dispatch(PromoteIncomeActionCreator.setLoadData(model));
  } catch (e) {
    ctx.state.requestController.requestFail();
    ctx.state.refreshController.refreshFailed();
  }
}

void _loadMoreData(Action action, Context<PromoteIncomeState> ctx) async {
  try {
    var number = ctx.state.pageNumber + 1;
    var model =
        await netManager.client.getInviteIncomeList(ctx.state.pageSize, number);

    if (!model.hasNext) {
      ctx.state.refreshController.loadNoData();
    } else {
      ctx.state.refreshController.loadComplete();
    }

    ctx.dispatch(
        PromoteIncomeActionCreator.setMoreLoadData(model.inviteItemList ?? []));
  } catch (e) {
    ctx.state.refreshController.loadFailed();
  }
}
