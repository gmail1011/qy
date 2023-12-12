import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<YuePaoSelectCityState> buildReducer() {
  return asReducer(
    <Object, Reducer<YuePaoSelectCityState>>{
      YuePaoSelectCityAction.setCityData: _setCity,
      YuePaoSelectCityAction.setSearchCityData: _setSearchCity,
      YuePaoSelectCityAction.setHotCityData: _getHotListSuccess,
    },
  );
}

YuePaoSelectCityState _setSearchCity(
    YuePaoSelectCityState state, Action action) {
  final YuePaoSelectCityState newState = state.clone();
  newState.searchList = action.payload ?? [];

  return newState;
}

YuePaoSelectCityState _setCity(YuePaoSelectCityState state, Action action) {
  final YuePaoSelectCityState newState = state.clone();
  newState.cityList = action.payload ?? [];
  newState.searchList = action.payload ?? [];

  return newState;
}

YuePaoSelectCityState _getHotListSuccess(
    YuePaoSelectCityState state, Action action) {
  final YuePaoSelectCityState newState = state.clone()
    ..hotCityList = action.payload ?? [];
  return newState;
}
