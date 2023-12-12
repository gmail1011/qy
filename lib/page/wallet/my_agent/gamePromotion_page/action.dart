import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/game_promotion_entity.dart';
import 'package:flutter_app/model/wallet/user_income_model.dart';

//TODO replace with your own action
enum GamePromotionAction { onWithdraw, refreshData, onService,setUserData }

class GamePromotionActionCreator {

  static Action onWithdraw() {
    return Action(GamePromotionAction.onWithdraw);
  }

  static Action refreshData(GamePromotionData model) {
    return Action(GamePromotionAction.refreshData, payload: model);
  }
  static Action setUserData(UserIncomeModel userIncomeModel) {
    return Action(GamePromotionAction.setUserData, payload: userIncomeModel);
  }

  static Action onService() {
    return const Action(GamePromotionAction.onService);
  }
}
