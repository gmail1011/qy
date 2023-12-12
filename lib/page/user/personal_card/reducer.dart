import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PersonalCardState> buildReducer() {
  return asReducer(
    <Object, Reducer<PersonalCardState>>{
      PersonalCardAction.onLoadData: _onLoadData,
    },
  );
}

PersonalCardState _onLoadData(PersonalCardState state, Action action) {
  final PersonalCardState newState = state.clone();
  return newState;
}
