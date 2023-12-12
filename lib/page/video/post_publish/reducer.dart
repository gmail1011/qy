import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PostPublishState> buildReducer() {
  return asReducer(
    <Object, Reducer<PostPublishState>>{
      PostPublishAction.refreshUI: _refreshUI,
    },
  );
}

PostPublishState _refreshUI(PostPublishState state, Action action) {
  final PostPublishState newState = state.clone();
  return newState;
}
