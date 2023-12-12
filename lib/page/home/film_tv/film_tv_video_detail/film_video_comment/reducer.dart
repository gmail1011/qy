import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<FilmVideoCommentState> buildReducer() {
  return asReducer(
    <Object, Reducer<FilmVideoCommentState>>{
      FilmVideoCommentAction.updateUI: _updateUI,
    },
  );
}

FilmVideoCommentState _updateUI(FilmVideoCommentState state, Action action) {
  final FilmVideoCommentState newState = state.clone();
  return newState;
}
