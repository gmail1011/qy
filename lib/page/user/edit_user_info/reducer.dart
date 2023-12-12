import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<EditUserInfoState> buildReducer() {
  return asReducer(
    <Object, Reducer<EditUserInfoState>>{
      EditUserInfoAction.refresh: _onRefresh,
      EditUserInfoAction.changePhoto: _onChangePhoto,
    },
  );
}

EditUserInfoState _onRefresh(EditUserInfoState state, Action action) {
  final EditUserInfoState newState = state.clone();
  return newState;
}

EditUserInfoState _onChangePhoto(EditUserInfoState state, Action action) {
  final EditUserInfoState newState = state.clone()..tempPhoto = action.payload;
  return newState;
}
