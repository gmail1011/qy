import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<EditSummaryState> buildReducer() {
  return asReducer(
    <Object, Reducer<EditSummaryState>>{
      EditSummaryAction.updateUI: _updateUI,
    },
  );
}

EditSummaryState _updateUI(EditSummaryState state, Action action) {
  final EditSummaryState newState = state.clone();
  return newState;
}
