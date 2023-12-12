import 'package:fish_redux/fish_redux.dart';

import 'select_tags_action.dart';
import 'select_tags_state.dart';

Reducer<SelectTagsState> buildReducer() {
  return asReducer(
    <Object, Reducer<SelectTagsState>>{
      SelectTagsAction.action: _onAction,
    },
  );
}

SelectTagsState _onAction(SelectTagsState state, Action action) {
  final SelectTagsState newState = state.clone();
  return newState;
}
