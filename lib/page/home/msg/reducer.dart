import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/message/message_type_model.dart';

import 'action.dart';
import 'state.dart';

Reducer<MsgState> buildReducer() {
  return asReducer(
    <Object, Reducer<MsgState>>{
      MsgAction.onLoadMessageTypeAction: _onLoadMessageType,
      MsgAction.getAdsOkay: _getAdsOkay,
    },
  );
}

MsgState _getAdsOkay(MsgState state, Action action) {
  final MsgState newState = state.clone();
  var ad = action.payload as AdsInfoBean;
  return newState..adsBean = ad;
}

MsgState _onLoadMessageType(MsgState state, Action action) {
  final MsgState newState = state.clone();
  newState.messageTypeModel = action.payload;
  if (newState.messageModelList != null &&
      newState.messageModelList.length > 1) {
    newState.messageModelList.removeRange(1, newState.messageModelList.length);
  }
  newState.messageModelList
      .addAll((action.payload as MessageTypeModel).noticePreList);
  return newState;
}
