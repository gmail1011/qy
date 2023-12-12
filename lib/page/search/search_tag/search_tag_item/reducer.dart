import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SearchTagItemState> buildReducer() {
  return asReducer(
    <Object, Reducer<SearchTagItemState>>{
      SearchTagItemAction.action: _onAction,
    },
  );
}

SearchTagItemState _onAction(SearchTagItemState state, Action action) {
  final SearchTagItemState newState = state.clone();
  return newState;
}
