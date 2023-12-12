import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/announce_liao_ba_entity.dart';
import 'package:flutter_app/model/wallet/user_income_model.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/page/wallet/my_agent/ExangeMarquee.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import '../../../common/manager/cs_manager.dart';
import 'action.dart';
import 'state.dart';

Effect<MyAgentState> buildEffect() {
  return combineEffects(<Object, Effect<MyAgentState>>{
    Lifecycle.initState: _initState,
    MyAgentAction.onRule: _onRule,
    MyAgentAction.onService: _onService,
  });
}

void _initState(Action action, Context<MyAgentState> ctx) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    try {
      WalletModelEntity userIncomeModel = await GlobalStore.refreshWallet();
      ctx.dispatch(MyAgentActionCreator.refreshData(userIncomeModel));


      _onGetAnnounce(action,ctx);

      ctx.state.requestController?.requestSuccess();
    } catch (e) {
      l.e('getUserAllIncomeInfo', e.toString());
      ctx.state.requestController?.requestFail();
    }
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}


Future _onGetAnnounce(
    Action action, Context<MyAgentState> ctx) async {
  try {

    dynamic specialModel = await netManager.client.getExchangeMarQuee();

    List<Datum> data = List<Datum>.from(specialModel.map((x) => Datum.fromJson(x)));

    StringBuffer stringBuffer = new StringBuffer();
    data.forEach((element) {
      stringBuffer.write(element.content + "               ");
    });
    ctx.dispatch(MyAgentActionCreator.onGetMarquee(stringBuffer.toString()));
  } catch (e) {
    l.e("getGroup", e);
  }
}

void _onRule(Action action, Context<MyAgentState> ctx) {
  //代理规则
  JRouter().handleAdsInfo(Address.proxyRuleUrl);
}

void _onService(Action action, Context<MyAgentState> ctx) async {
  csManager.openServices(ctx.context);
}
