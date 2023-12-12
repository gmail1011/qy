import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<YuePaoVerificationState> buildReducer() {
  return asReducer(
    <Object, Reducer<YuePaoVerificationState>>{
      YuePaoVerificationAction.onUpdatePic: _onUpdatePic,
    },
  );
}

YuePaoVerificationState _onUpdatePic(YuePaoVerificationState state, Action action) {
  final YuePaoVerificationState newState = state.clone()
  ..localPicList.addAll(action.payload??[]);
  return newState;
}
