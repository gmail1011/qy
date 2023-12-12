import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<FilmVideoIntroductionState> buildReducer() {
  return asReducer(
    <Object, Reducer<FilmVideoIntroductionState>>{
      FilmVideoIntroductionAction.updateUI: _updateUI,
      FilmVideoIntroductionAction.updateFollowState: _updateFollowState,
    },
  );
}

FilmVideoIntroductionState _updateUI(
    FilmVideoIntroductionState state, Action action) {
  final FilmVideoIntroductionState newState = state.clone();
  return newState;
}

FilmVideoIntroductionState _updateFollowState(
    FilmVideoIntroductionState state, Action action) {
  final FilmVideoIntroductionState newState = state.clone();
  newState.viewModel?.publisher?.hasFollowed = action.payload as bool;
  return newState;
}
