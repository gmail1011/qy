import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<TopicState> buildReducer() {
  return asReducer(
    <Object, Reducer<TopicState>>{
      TopicAction.updateUI: _updateUI,
    },
  );
}

TopicState _updateUI(TopicState state, Action action) {
  final TopicState newState = state.clone();
  return newState;
}
