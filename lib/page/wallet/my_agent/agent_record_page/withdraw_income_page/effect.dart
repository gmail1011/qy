import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'action.dart';
import 'state.dart';

Effect<WithdrawIncomeState> buildEffect() {
  return combineEffects(<Object, Effect<WithdrawIncomeState>>{
    WithdrawIncomeAction.loadData: _loadData,
    WithdrawIncomeAction.loadMoreData: _loadMoreData,
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<WithdrawIncomeState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () {
    _loadData(action, ctx);
  });
}

void _loadData(Action action, Context<WithdrawIncomeState> ctx) async {
  try {
    var model =
        await netManager.client.getWithdrawDetails(1, ctx.state.pageSize);

    if ((model.list?.length ?? 0) == 0) {
      ctx.state.requestController.requestDataEmpty();
    } else {
      if (!model.hasNext) {
        ctx.state.refreshController.loadNoData();
      }
      ctx.state.requestController.requestSuccess();
    }
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    ctx.dispatch(WithdrawIncomeActionCreator.setLoadData(model.list));
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
    ctx.state.requestController.requestFail();
  }
}

void _loadMoreData(Action action, Context<WithdrawIncomeState> ctx) async {
  try {
    var number = ctx.state.pageNumber + 1;
    var model =
        await netManager.client.getWithdrawDetails(number, ctx.state.pageSize);
    if (model.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
    ctx.dispatch(WithdrawIncomeActionCreator.setLoadMoreData(model.list));
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
  }
}
