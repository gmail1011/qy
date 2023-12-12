import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/anchor_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<VoiceAnchorDataListState> buildEffect() {
  return combineEffects(<Object, Effect<VoiceAnchorDataListState>>{
    Lifecycle.initState: _initState,
    VoiceAnchorDataListAction.loadData: _loadData,
    VoiceAnchorDataListAction.loadMoreData: _loadMoreData,
  });
}

void _initState(Action action, Context<VoiceAnchorDataListState> ctx) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    Future.delayed(Duration(milliseconds: 200), () async {
      _loadData(action, ctx);
    });
  });
}

void _loadData(Action action, Context<VoiceAnchorDataListState> ctx) async {
  var model = await _getNetData(ctx, 1);
  if (model == null) {
    ctx.state.pullRefreshController.requestFail(isFirstPageNum: true);
    return;
  }
  ctx.state.pullRefreshController.requestSuccess(
    isFirstPageNum: true,
    hasMore: model.hasNext,
    isEmpty: (model.list?.length ?? 0) == 0,
  );
  ctx.dispatch(VoiceAnchorDataListActionCreator.setLoadData(model.list));
}

void _loadMoreData(Action action, Context<VoiceAnchorDataListState> ctx) async {
  var number = ctx.state.pageNumber + 1;
  var model = await _getNetData(ctx, number);
  if (model == null) {
    ctx.state.pullRefreshController.requestFail(isFirstPageNum: false);
    return;
  }
  ctx.state.pullRefreshController.requestSuccess(
    isFirstPageNum: false,
    hasMore: model.hasNext,
  );
  ctx.dispatch(VoiceAnchorDataListActionCreator.setLoadMoreData(model.list));
}

Future<AnchorModel> _getNetData(
    Context<VoiceAnchorDataListState> ctx, int number) async {
  AnchorModel model;
  try {
    if (ctx.state.type == 1) {
      model = await netManager.client.getAnchorList(
        ctx.state.pageSize,
        number,
      );
    } else if (ctx.state.type == 2) {
      model = await netManager.client.getAnchorCollectList(
        number,
        ctx.state.pageSize,
        GlobalStore.getMe().uid,
      );
    }
  } catch (e) {
    l.d("_getNetData", _getNetData);
  }
  return model;
}
