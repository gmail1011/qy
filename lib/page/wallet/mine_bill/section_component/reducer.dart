import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SectionState> buildReducer() {
  return asReducer(
    <Object, Reducer<SectionState>>{
      SectionAction.action: _onAction,
    },
  );
}

SectionState _onAction(SectionState state, Action action) {
  final SectionState newState = state.clone();
  return newState;
}
