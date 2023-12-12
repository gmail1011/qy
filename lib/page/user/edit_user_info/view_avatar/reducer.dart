import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ViewAvatarState> buildReducer() {
  return asReducer(
    <Object, Reducer<ViewAvatarState>>{
      ViewAvatarAction.loadViewAvatarAction: _onLoadViewAvatar,
    },
  );
}

ViewAvatarState _onLoadViewAvatar(ViewAvatarState state, Action action) {
  final ViewAvatarState newState = state.clone();
  return newState;
}
