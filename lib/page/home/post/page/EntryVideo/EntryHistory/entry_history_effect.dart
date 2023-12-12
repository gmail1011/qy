import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/entry_history_entity.dart';
import 'package:flutter_app/model/entry_video_entity.dart';

import 'entry_history_action.dart';
import 'entry_history_state.dart';

Effect<EntryHistoryState> buildEffect() {
  return combineEffects(<Object, Effect<EntryHistoryState>>{
    EntryHistoryAction.action: _onAction,
    EntryHistoryAction.onLoadMore: _onLoadMore,
    Lifecycle.initState: _onInitData,
  });
}

void _onAction(Action action, Context<EntryHistoryState> ctx) async {
  dynamic entryHistory = await netManager.client
      .getEntryVideoHistory(ctx.state.pageNumber, ctx.state.pageSize);

  EntryHistoryData entryHistoryData = EntryHistoryData().fromJson(entryHistory);

  ctx.dispatch(EntryHistoryActionCreator.onInitData(entryHistoryData));
}

void _onInitData(Action action, Context<EntryHistoryState> ctx) async {
  dynamic entryHistory = await netManager.client
      .getEntryVideoHistory(ctx.state.pageNumber, ctx.state.pageSize);

  EntryHistoryData entryHistoryData = EntryHistoryData().fromJson(entryHistory);

  ctx.dispatch(EntryHistoryActionCreator.onInitData(entryHistoryData));
}

void _onLoadMore(Action action, Context<EntryHistoryState> ctx) async {
  dynamic entryHistory = await netManager.client
      .getEntryVideoHistory(action.payload, ctx.state.pageSize);

  EntryHistoryData entryHistoryData = EntryHistoryData().fromJson(entryHistory);

  if (entryHistoryData.activityList.length == 0) {
    ctx.state.refreshController.loadNoData();
  } else {
    if (action.payload == 1) {
      ctx.dispatch(
          EntryHistoryActionCreator.onInitData(entryHistoryData));
      ctx.state.refreshController.refreshCompleted();
    } else {
      ctx.state.entryHistoryData.activityList
          .addAll(entryHistoryData.activityList);

      ctx.dispatch(
          EntryHistoryActionCreator.onInitData(ctx.state.entryHistoryData));

      ctx.state.refreshController.loadComplete();
    }
  }
}
