import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/game_promotion_entity.dart';
import 'package:flutter_app/model/wallet/user_income_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<GameIncomeRecordState> buildEffect() {
  return combineEffects(<Object, Effect<GameIncomeRecordState>>{
    GameIncomeRecordAction.loadData: _loadData,
    GameIncomeRecordAction.loadMoreData: _loadMoreData,
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<GameIncomeRecordState> ctx) {
  _loadData(action, ctx);
}

void _loadData(Action action, Context<GameIncomeRecordState> ctx) async {
  try {
    int pageNumber = ctx.state.pageNumber;
    int pageSize = ctx.state.pageSize;
    GamePromotionData gamePromotionData =
        await netManager.client.getIncomeInfo(pageSize, pageNumber);

    UserIncomeModel userIncomeModel =  await netManager.client.getGameAllIncomeInfo();
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);

    ctx.state.gamePromotionData = gamePromotionData;
    if ((gamePromotionData?.xList?.length ?? 0) == 0) {
      ctx.state.requestController.requestDataEmpty();
    } else {
      if (!gamePromotionData.hasNext) {
        ctx.state.refreshController.loadNoData();
      }
      ctx.state.requestController.requestSuccess();
    }
    ctx.dispatch(GameIncomeRecordActionCreator.refreshData(userIncomeModel));
    ctx.dispatch(
        GameIncomeRecordActionCreator.onSetLoadData(gamePromotionData));
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
    ctx.state.requestController.requestFail();
    l.d('getProxyBindRecord', e.toString());
  }
}

void _loadMoreData(Action action, Context<GameIncomeRecordState> ctx) async {
  int pageNumber = ctx.state.pageNumber + 1;
  int pageSize = ctx.state.pageSize;
  try {
    GamePromotionData gamePromotionData =
        await netManager.client.getIncomeInfo(pageSize, pageNumber);
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);

    ctx.dispatch(
        GameIncomeRecordActionCreator.onSetMoreData(gamePromotionData));
    if (gamePromotionData.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
    l.d('getProxyBindRecord', e.toString());
  }
}
