import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<OfficialCommunityState> buildReducer() {
  return asReducer(
    <Object, Reducer<OfficialCommunityState>>{
      OfficialCommunityAction.updateUI: _updateUI,
    },
  );
}

OfficialCommunityState _updateUI(OfficialCommunityState state, Action action) {
  final OfficialCommunityState newState = state.clone();
  return newState;
}
