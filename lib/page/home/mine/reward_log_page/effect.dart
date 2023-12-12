import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/reward_list_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'action.dart';
import 'state.dart';

Effect<RewardLogState> buildEffect() {
  return combineEffects(<Object, Effect<RewardLogState>>{
    Lifecycle.initState: _initData,
    RewardLogAction.onLoadMore: _onLoadMore,

  });
}

void _initData(Action action, Context<RewardLogState> ctx) {
  _getData(ctx, 1);
  Future.delayed(Duration(milliseconds: 200)).then((_) {
    //eaglePage(ctx.state.selfId(),
         // sourceId: ctx.state.eagleId(ctx.context));
  });
}

/// 加载更多数据
void _onLoadMore(Action action, Context<RewardLogState> ctx){
  int pageNumber = ctx.state.pageNum++;
  _getData(ctx, pageNumber);
}

/// 获取数据
void _getData(Context<RewardLogState> ctx, int pageNumber) async{
  // int pageNumber =  ctx.state.pageNum;
  RewardListModel rewardListModel;
  try {
    rewardListModel = await netManager.client.getRewardUserList(pageNumber);
    // 请求成功
    if (pageNumber == 1) {
      // 刷新成功
      ctx.state.refreshController.refreshCompleted(resetFooterState: true);

    } else {
      // 加载成功
      ctx.state.refreshController.loadComplete();
    }
    ctx.dispatch(RewardLogActionCreator.onRefreshOkay(rewardListModel.list, pageNumber));
    // 加载成功之后没有更多
    if (!rewardListModel.hasNext) {
      ctx.state.refreshController.loadNoData();
    }
  } catch (e) {
    // 请求失败
    if (pageNumber == 1) {
      // 刷新失败
      ctx.state.refreshController.refreshFailed();
    } else {
      // 加载失败
      ctx.state.refreshController.loadFailed();
    }
    l.e("getRewardUserList", e.toString());
  }
}
