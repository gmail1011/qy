import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/discovery_tab_page/state.dart';

import 'action.dart';
import 'state.dart';

Reducer<FilmTelevisionState> buildReducer() {
  return asReducer(
    <Object, Reducer<FilmTelevisionState>>{
      FilmTelevisionAction.action: _onAction,
      FilmTelevisionAction.onRefreshUI: _onRefreshUI,
    },
  );
}

FilmTelevisionState _onAction(FilmTelevisionState state, Action action) {
  final FilmTelevisionState newState = state.clone();
  return newState;
}

FilmTelevisionState _onRefreshUI(FilmTelevisionState state, Action action) {
  final FilmTelevisionState newState = state.clone();
  return newState;
}
