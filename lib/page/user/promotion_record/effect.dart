import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<PromotionRecordState> buildEffect() {
  return combineEffects(<Object, Effect<PromotionRecordState>>{
    Lifecycle.initState: _init,
    PromotionRecordAction.loadData: _loadData,
    PromotionRecordAction.loadMoreData: _loadMoreData,
  });
}

void _init(Action action, Context<PromotionRecordState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () {
   // eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
    _loadData(action, ctx);
  });
}

void _loadData(Action action, Context<PromotionRecordState> ctx) async {
  try {
    var record =
        await netManager.client.getProxyBindRecord(ctx.state.pageSize, 1);
    ctx.dispatch(PromotionRecordActionCreator.setLoadData(record));
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    if (!record.hasNext) {
      ctx.state.refreshController.loadNoData();
    }

    if ((record?.total ?? 0) == 0) {
      ctx.state.requestController.requestDataEmpty();
    } else {
      ctx.state.requestController.requestSuccess();
    }
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
    ctx.state.requestController.requestFail();
    l.d('getProxyBindRecord', e.toString());
  }
}

void _loadMoreData(Action action, Context<PromotionRecordState> ctx) async {
  var number = ctx.state.pageNumber + 1;
  try {
    var record =
        await netManager.client.getProxyBindRecord(ctx.state.pageSize, number);
    ctx.dispatch(
        PromotionRecordActionCreator.setLoadMoreData(record.promotionList));
    if (record.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
  } catch (e) {
    l.d('getProxyBindRecord', e.toString());
    ctx.state.refreshController.loadFailed();
  }
}
