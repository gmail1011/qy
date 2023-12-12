import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/promotion_record.dart';

import 'action.dart';
import 'state.dart';

Reducer<PromotionRecordState> buildReducer() {
  return asReducer(
    <Object, Reducer<PromotionRecordState>>{
      PromotionRecordAction.setLoadData: _setLoadData,
      PromotionRecordAction.setLoadMoreData: _setLoadMoreData,
    },
  );
}

PromotionRecordState _setLoadData(PromotionRecordState state, Action action) {
  final PromotionRecordState newState = state.clone();
  var model = action.payload as PromotionModel;
  newState.promotionList = model.promotionList;
  newState.total = model.total;
  newState.pageNumber = 1;
  return newState;
}

PromotionRecordState _setLoadMoreData(
    PromotionRecordState state, Action action) {
  final PromotionRecordState newState = state.clone();
  newState.promotionList.addAll(action.payload);
  newState.pageNumber++;
  return newState;
}
