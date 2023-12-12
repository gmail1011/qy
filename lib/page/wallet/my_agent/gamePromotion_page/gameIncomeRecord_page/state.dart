import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/game_promotion_entity.dart';
import 'package:flutter_app/model/wallet/user_income_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GameIncomeRecordState implements Cloneable<GameIncomeRecordState> {
  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();
  GamePromotionData gamePromotionData;
  UserIncomeModel userIncomeModel;
  List<GamePromotionDataList> dataList = [];
  int pageNumber = 1;
  int pageSize = 10;
  @override
  GameIncomeRecordState clone() {
    return GameIncomeRecordState()
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..refreshController = refreshController
      ..requestController = requestController
      ..gamePromotionData = gamePromotionData
      ..dataList = dataList
      ..userIncomeModel = userIncomeModel;
  }
}

GameIncomeRecordState initState(Map<String, dynamic> args) {
  return GameIncomeRecordState();
}
