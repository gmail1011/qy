import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';

import 'action.dart';
import 'state.dart';

Effect<RevenueCenterState> buildEffect() {
  return combineEffects(<Object, Effect<RevenueCenterState>>{
    // RevenueCenterAction.action: _onAction,
    // Lifecycle.initState: _initState,
  });
}

void _initState(Action action, Context<RevenueCenterState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () {
    _loadData(action, ctx);
  });
}

void _loadData(Action action, Context<RevenueCenterState> ctx) async {
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
    ctx.state.pageNumber = 1;
    ctx.state.model = model;
    ctx.state.videoIncomeList = model?.videoIncomeList ?? [];
    ctx.dispatch(RevenueCenterActionCreator.updateUI());
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
    ctx.state.requestController.requestFail();
  }
}

void _loadMoreData(Action action, Context<RevenueCenterState> ctx) async {
  try {
    var number = ctx.state.pageNumber + 1;
    var model =
        await netManager.client.getVideoIncomeList(ctx.state.pageSize, number);
    if (model.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }

    ctx.state.pageNumber++;
    ctx.state.videoIncomeList.addAll(model?.videoIncomeList);
    ctx.dispatch(RevenueCenterActionCreator.updateUI());
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
  }
}
