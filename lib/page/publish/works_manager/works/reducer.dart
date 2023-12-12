import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WorksListState> buildReducer() {
  return asReducer(
    <Object, Reducer<WorksListState>>{
      WorksListAction.updateUI: _updateUI,
    },
  );
}

WorksListState _updateUI(WorksListState state, Action action) {
  final WorksListState newState = state.clone();
  return newState;
}
