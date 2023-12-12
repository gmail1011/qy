import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/wallet/user_income_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';

enum MyAgentAction { onRule, refreshData, onService , getMarquee }

class MyAgentActionCreator {
  static Action onRule() {
    return const Action(MyAgentAction.onRule);
  }

  static Action refreshData(WalletModelEntity userIncomeModel) {
    return Action(MyAgentAction.refreshData, payload: userIncomeModel);
  }

  static Action onService() {
    return const Action(MyAgentAction.onService);
  }

  static Action onGetMarquee(String marquee) {
    return Action(MyAgentAction.getMarquee,payload: marquee);
  }
}
