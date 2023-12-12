import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<YuePaoState> buildReducer() {
  return asReducer(
    <Object, Reducer<YuePaoState>>{
      YuePaoAction.onChangeCity: _onChangeCity,
      YuePaoAction.getAdsSuccess: _getAdsSuccess,
    },
  );
}

YuePaoState _onChangeCity(YuePaoState state, Action action) {
  final YuePaoState newState = state.clone()
  ..city = action.payload??'';
  return newState;
}

YuePaoState _getAdsSuccess(YuePaoState state, Action action) {
  final YuePaoState newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}

