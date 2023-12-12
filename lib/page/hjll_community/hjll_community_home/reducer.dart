import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HjllCommunityHomeState> buildReducer() {
  return asReducer(
    <Object, Reducer<HjllCommunityHomeState>>{
      HjllCommunityHomeAction.action: _onAction,
    },
  );
}

HjllCommunityHomeState _onAction(HjllCommunityHomeState state, Action action) {
  final HjllCommunityHomeState newState = state.clone();
  return newState;
}
