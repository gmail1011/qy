import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/liao_ba_history_entity.dart';
import 'package:flutter_app/model/selected_tags_entity.dart';

import 'history_action.dart';
import 'history_state.dart';

Effect<HistoryState> buildEffect() {
  return combineEffects(<Object, Effect<HistoryState>>{
    HistoryAction.action: _onInitData,
    Lifecycle.initState: _onInitData,
    HistoryAction.loadMore: _onLoadMore,
  });
}

void _onAction(Action action, Context<HistoryState> ctx) {}

void _onInitData(Action action, Context<HistoryState> ctx) async {
  dynamic specialModel = await netManager.client
      .getLiaoBaTabHistory(ctx.state.pageNumber, ctx.state.pageSize);

  LiaoBaHistoryData liaoBaHistoryData =
      LiaoBaHistoryData().fromJson(specialModel);

  ctx.dispatch(HistoryActionCreator.onInitData(liaoBaHistoryData));

  ctx.state.refreshController.refreshCompleted(resetFooterState: true);
  if ((liaoBaHistoryData.workList.length ?? 0) == 0) {
    ctx.state.baseRequestController.requestDataEmpty();
  } else {
    ctx.state.baseRequestController.requestSuccess();
  }
}

void _onLoadMore(Action action, Context<HistoryState> ctx) async {
  dynamic specialModel = await netManager.client
      .getLiaoBaTabHistory(action.payload, ctx.state.pageSize);

  LiaoBaHistoryData liaoBaHistoryData =
      LiaoBaHistoryData().fromJson(specialModel);

  if ((liaoBaHistoryData.workList.length ?? 0) == 0) {
    ctx.state.refreshController.loadNoData();
  } else {
    ctx.state.liaoBaHistoryData.workList.addAll(liaoBaHistoryData.workList);
    ctx.dispatch(HistoryActionCreator.onInitData(ctx.state.liaoBaHistoryData));

    ctx.state.baseRequestController.requestSuccess();

    ctx.state.refreshController.loadComplete();
  }
}
