import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SearchResultState> buildReducer() {
  return asReducer(
    <Object, Reducer<SearchResultState>>{
      SearchResultAction.setKeywords: _setKeywords,
    },
  );
}

SearchResultState _setKeywords(SearchResultState state, Action action) {
  final SearchResultState newState = state.clone();
  newState.keywords = action.payload ?? '';
  return newState;
}
