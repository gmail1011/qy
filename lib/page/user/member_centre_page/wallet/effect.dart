import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/wallet/recharge_list_model.dart';

import 'action.dart';
import 'gold_tickets.dart';
import 'state.dart';

Effect<WalletState> buildEffect() {
  return combineEffects(<Object, Effect<WalletState>>{
    Lifecycle.initState: _initState,
  });
}

void _initState(Action action, Context<WalletState> ctx) {
  ///钱包初始化
  _getRecharges(ctx);


  _getTickets(ctx);


}

/// 获取充值金币列表
void _getRecharges(Context<WalletState> ctx) async {
  try {
    RechargeListModel model =
        await netManager.client.getNakeChatRechargeTypeList(1);

    if (null != model) {
      VariableConfig.rechargeType = model.list;
      ctx.state.rechargeType = model.list;
      for(int i = 0; i < (model.list?.length ?? 0); i++){
        var rechargeModel = model.list[i];
        if(rechargeModel.hotStatus == true){
          ctx.state.selectIndex = i;
          break;
        }
      }
      if (model.daichong != null) {
        ctx.state.dcModel = model.daichong;
      }
      ctx.state.requestController.requestSuccess();
    } else {
      ctx.state.requestController.requestDataEmpty();
    }
  } catch (e) {
    ctx.state.requestController.requestFail();
  }
  ctx.dispatch(WalletActionCreator.updateUI());
}


/// 获取充值金币列表
void _getTickets(Context<WalletState> ctx) async {


  try {

    dynamic model = await netManager.client.getTickets(1,100,1);

    if (null != model) {


      VariableConfig.goldTickets = GoldTickets.fromJson(model);


    } else {

    }
  } catch (e) {

  }


  ctx.dispatch(WalletActionCreator.updateUI());
}
