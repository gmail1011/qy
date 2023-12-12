import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<NovelSearchResultState> buildReducer() {
  return asReducer(
    <Object, Reducer<NovelSearchResultState>>{
      NovelSearchResultAction.setKeywords: _setKeywords,
    },
  );
}

NovelSearchResultState _setKeywords(
    NovelSearchResultState state, Action action) {
  final NovelSearchResultState newState = state.clone();
  newState.keywords = action.payload ?? '';
  return newState;
}
