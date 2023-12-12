import 'package:fish_redux/fish_redux.dart';

import '../state.dart';
import 'action.dart';

Reducer<CityVideoState> buildReducer() {
  return asReducer(
    <Object, Reducer<CityVideoState>>{
      CityAdapterAction.action: _onAction,
    },
  );
}

CityVideoState _onAction(CityVideoState state, Action action) {
  final CityVideoState newState = state.clone();
  return newState;
}
