import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/game_promotion_entity.dart';
import 'package:flutter_app/model/wallet/user_income_model.dart';

class GamePromotionState implements Cloneable<GamePromotionState> {
  GamePromotionData gamePromotionData;
  UserIncomeModel userIncomeModel;
  @override
  GamePromotionState clone() {
    return GamePromotionState()
      ..gamePromotionData = gamePromotionData
      ..userIncomeModel = userIncomeModel;
  }
}

GamePromotionState initState(Map<String, dynamic> args) {
  return GamePromotionState();
}
