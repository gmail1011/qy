import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/game_promotion_entity.dart';
import 'package:flutter_app/model/wallet/user_income_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<GamePromotionState> buildEffect() {
  return combineEffects(<Object, Effect<GamePromotionState>>{
    Lifecycle.initState: _initState,
    GamePromotionAction.onWithdraw: _onWithdraw,
    GamePromotionAction.onService: _onService,
  });
}

void _initState(Action action, Context<GamePromotionState> ctx) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    try {
      GamePromotionData gamePromotionData =
      await netManager.client.getIncomeInfo(10,1);
      UserIncomeModel userIncomeModel =  await netManager.client.getGameAllIncomeInfo();
      ctx.dispatch(GamePromotionActionCreator.refreshData(gamePromotionData));
      ctx.dispatch(GamePromotionActionCreator.setUserData(userIncomeModel));
    } catch (e) {
      l.e('getUserAllIncomeInfo', e.toString());
    }
  });
}

void _onWithdraw(Action action, Context<GamePromotionState> ctx) {
  JRouter().go(PAGE_WITHDRAW);
}

void _onService(Action action, Context<GamePromotionState> ctx) async {
  csManager.openServices(ctx.context);
}
