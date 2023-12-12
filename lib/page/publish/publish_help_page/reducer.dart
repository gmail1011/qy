import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PublishHelpState> buildReducer() {
  return asReducer(
    <Object, Reducer<PublishHelpState>>{
      PublishHelpAction.action: _onAction,
    },
  );
}

PublishHelpState _onAction(PublishHelpState state, Action action) {
  final PublishHelpState newState = state.clone();
  return newState;
}
