import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/user/vip_buy_history.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<PurchaseDetailState> buildEffect() {
  return combineEffects(<Object, Effect<PurchaseDetailState>>{
    Lifecycle.initState: _init,
    PurchaseDetailAction.loadMore: _getLoadMore,
    PurchaseDetailAction.loadData: _getRefreshDetail,
  });
}

void _init(Action action, Context<PurchaseDetailState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () async {
    _getRefreshDetail(action, ctx);
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

void _getRefreshDetail(Action action, Context<PurchaseDetailState> ctx) async {
  int pageSize = ctx.state.pageSize;
  try {
    VipBuyHistory model = await netManager.client.getVipHistory(pageSize, 1);
    ctx.dispatch(PurchaseDetailActionCreator.setRefreshDetail(model.list));
    if (model == null || model.list.length == 0) {
      ctx.state.baseRequestController.requestDataEmpty();
    } else {
      ctx.state.baseRequestController.requestSuccess();
    }
  } catch (e) {
    l.d('getVipHistory', e.toString());
    ctx.state.baseRequestController.requestFail();
  }
}

void _getLoadMore(Action action, Context<PurchaseDetailState> ctx) async {
  int pageNumber = ctx.state.pageNumber + 1;
  try {
    var model =
        await netManager.client.getVipHistory(ctx.state.pageSize, pageNumber);
    ctx.dispatch(PurchaseDetailActionCreator.setLoadDetails(model.list));
    if (!model.hasNext) {
      ctx.state.refreshController.loadNoData();
    } else {
      ctx.state.refreshController.loadComplete();
    }
  } catch (e) {
    ctx.state.refreshController.loadFailed();
    l.d('getVipHistory', e.toString());
  }
}
