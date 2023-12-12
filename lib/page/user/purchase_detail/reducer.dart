import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PurchaseDetailState> buildReducer() {
  return asReducer(
    <Object, Reducer<PurchaseDetailState>>{
      PurchaseDetailAction.action: _onAction,
      PurchaseDetailAction.setRefreshDetail: _setRefreshDetail,
      PurchaseDetailAction.setLoadDetails: _setLoadDetails,
    },
  );
}

PurchaseDetailState _onAction(PurchaseDetailState state, Action action) {
  final PurchaseDetailState newState = state.clone();
  return newState;
}

PurchaseDetailState _setRefreshDetail(
    PurchaseDetailState state, Action action) {
  final PurchaseDetailState newState = state.clone();
  newState.list = action.payload;
  newState.pageNumber = 1;
  return newState;
}

PurchaseDetailState _setLoadDetails(PurchaseDetailState state, Action action) {
  final PurchaseDetailState newState = state.clone();
  newState.list.addAll(action.payload);
  newState.pageNumber++;
  return newState;
}
