import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/alipay_bank_list_model.dart';

import 'action.dart';
import 'state.dart';

Reducer<AliListState> buildReducer() {
  return asReducer(
    <Object, Reducer<AliListState>>{
      AliListAction.updateData: _updateData,
      AliListAction.updateUI:_updateUI,
    },
  );
}

AliListState _updateData(AliListState state, Action action) {
  final AliListState newState = state.clone();
  ApBankListModel model = action.payload;
  newState.aliList = model.list;
  return newState;
}

AliListState _updateUI(AliListState state, Action action) {
  final AliListState newState = state.clone();
  return newState;
}
