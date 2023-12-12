import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/wallet/mine_bill/item_component/state.dart';
import 'package:flutter_app/page/wallet/mine_bill/model/bill_item_model.dart';
import 'package:flutter_app/page/wallet/mine_bill/model/mine_bill_section_model.dart';
import 'package:flutter_app/widget/custom_refresh_footer.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'action.dart';
import 'state.dart';

Effect<MineBillState> buildEffect() {
  return combineEffects(<Object, Effect<MineBillState>>{
    Lifecycle.initState: _initState,
    MineBillAction.onLoadData: _onLoadData,
    MineBillAction.onRefreshData: _onRefreshData
  });
}

void _initState(Action action, Context<MineBillState> ctx) async {
  ctx.state.header = ClassicalHeader(
    enableInfiniteRefresh: false,
    bgColor: null,
    textColor: Colors.white,
    float: false,
    showInfo: false,
    enableHapticFeedback: true,
    refreshText: "下拉刷新",
    refreshReadyText: "松开刷新",
    refreshingText: "刷新中...",
    refreshedText: "刷新完成",
    refreshFailedText: "刷新失败，请检查网络～",
  );
  ctx.state.footer = CustomRefreshFooter(
      loadText: "上拉加载",
      loadReadyText: "松开加载",
      loadingText: "加载中...",
      loadedText: "加载成功",
      loadFailedText: "加载失败，请检查网络～",
      noMoreText: "亲，人家也是有底线的哟～",
      showInfo: false,
      bgColor: Colors.transparent,
      textColor: Color(0xffBDBDBD),
      infoColor: Color(0xffBDBDBD),
      fontSize: 13,
      infoFontSize: 11);
  _onRefreshData(action, ctx);
  Future.delayed(Duration(milliseconds: 200), () {
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

///加载更多数据
void _onLoadData(Action action, Context<MineBillState> ctx) async {
  if (!ctx.state.hasNext) {
    ctx.state.refreshController.finishLoad(noMore: true);
    return;
  }
  ctx.state.isLoading = true;
  _loadData(action, ctx, false);
}

///刷新数据
void _onRefreshData(Action action, Context<MineBillState> ctx) async {
  ctx.state.isLoading = true;
  ctx.state.refreshController.resetLoadState();
  ctx.state.pageNumber = 0;
  ctx.state.billList = [];
  _loadData(action, ctx, true);
}

///加载数据
void _loadData(
    Action action, Context<MineBillState> ctx, bool isRefresh) async {
  MineBillSectionModel result;
  try {
    result = await netManager.client
        .getMyBillList(ctx.state.pageNumber + 1, ctx.state.pageSize);
  } catch (e) {
    l.e("bill_list", "_loadData:$e");
  }
  ctx.state.isLoading = false;
  if (result == null && isRefresh) {
    ctx.dispatch(MineBillActionCreator.loadDataFail());
    return;
  }
  ctx.state.hasNext = result.hasNext;
  MineBillItemState itemState;
  for (BillItemModel model in result.mineBillModel ?? []) {
    itemState = MineBillItemState();
    itemState.billModel = model;
    var date = DateTime.parse(itemState.billModel.createdAt).toLocal();
    var formatStr =
        "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}";
    itemState.billModel.createdAt = formatStr;
    ctx.state.billList.add(itemState);
  }

  if (ctx.state.billList.isEmpty) {
    if (ctx.state.hasNext) {
      ctx.state.pageNumber = 0;
      _loadData(action, ctx, isRefresh);
    } else {
      ctx.dispatch(MineBillActionCreator.loadDataFail());
    }
    return;
  }
  if (isRefresh) {
    ctx.state.refreshController.finishRefresh(success: true);
    ctx.state.requestComplete = true;
  } else {
    ctx.state.refreshController.finishLoad(success: true);
  }
  ctx.dispatch(MineBillActionCreator.loadDataSuccess());
  if (ctx.state.hasNext) {
    ctx.state.pageNumber++;
    return;
  }
  if (!ctx.state.hasNext && ctx.state.billList.length < ctx.state.maxCount) {
    if (!isRefresh) {
      ctx.state.refreshController.finishLoad(noMore: true);
    }
  }
}
