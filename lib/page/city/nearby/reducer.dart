import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<NearbyState> buildReducer() {
  return asReducer(
    <Object, Reducer<NearbyState>>{
      NearbyAction.RequestDataSuccess: _onRequestDataSuccess,
      NearbyAction.selectCitySuccess: _onSelectCitySuccess,
      NearbyAction.onError: _onError,
      NearbyAction.setIsShowTopBtn: _setIsShowTopBtn,
    },
  );
}

NearbyState _setIsShowTopBtn(NearbyState state, Action action) {
  final NearbyState newState = state.clone();
  newState.showToTopBtn = action.payload ?? false;
  return newState;
}

NearbyState _onRequestDataSuccess(NearbyState state, Action action) {
  final NearbyState newState = state.clone();
  return newState;
}

NearbyState _onSelectCitySuccess(NearbyState state, Action action) {
  final NearbyState newState = state.clone();
  newState.city = action.payload;
  newState.videoList.clear();
  return newState;
}

NearbyState _onError(NearbyState state, Action action) {
  final NearbyState newState = state.clone();
  newState.errorMsg = action.payload;
  newState.serverIsNormal = false;
  newState.requestSuccess = true;
  return newState;
}
