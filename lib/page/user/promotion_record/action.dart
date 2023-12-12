import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/promotion_record.dart';

enum PromotionRecordAction {
  loadData,
  setLoadData,
  loadMoreData,
  setLoadMoreData,
}

class PromotionRecordActionCreator {
  static Action loadData() {
    return const Action(PromotionRecordAction.loadData);
  }

  static Action setLoadData(PromotionModel model) {
    return Action(PromotionRecordAction.setLoadData, payload: model);
  }

  static Action loadMoreData() {
    return const Action(PromotionRecordAction.loadMoreData);
  }

  static Action setLoadMoreData(List<Promotion> promotionList) {
    return Action(PromotionRecordAction.setLoadMoreData,
        payload: promotionList);
  }
}
