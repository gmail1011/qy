import 'package:fish_redux/fish_redux.dart';

import 'publish_action.dart';
import 'publish_state.dart';

Reducer<PublishState> buildReducer() {
  return asReducer(
    <Object, Reducer<PublishState>>{
      PublishAction.action: _onAction,
    },
  );
}

PublishState _onAction(PublishState state, Action action) {
  final PublishState newState = state.clone();
  return newState;
}
