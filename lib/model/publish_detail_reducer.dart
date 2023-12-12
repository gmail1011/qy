import 'package:fish_redux/fish_redux.dart';

import 'publish_detail_action.dart';
import 'publish_detail_state.dart';

Reducer<PublishDetailState> buildReducer() {
  return asReducer(
    <Object, Reducer<PublishDetailState>>{
      PublishDetailAction.action: _onAction,
    },
  );
}

PublishDetailState _onAction(PublishDetailState state, Action action) {
  final PublishDetailState newState = state.clone();
  return newState;
}
