import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<TagState> buildReducer() {
  return asReducer(
    <Object, Reducer<TagState>>{
      TagAction.refreshUI: _refreshUI,
    },
  );
}

///刷新UI
TagState _refreshUI(TagState state, Action action) {
  final TagState newState = state.clone();
  return newState;
}
