import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PassionNovelState> buildReducer() {
  return asReducer(
    <Object, Reducer<PassionNovelState>>{
      PassionNovelAction.onAssignmentTab: _onAssignmentTab,
    },
  );
}

PassionNovelState _onAssignmentTab(PassionNovelState state, Action action) {
  var map = action.payload??{};
  final PassionNovelState newState = state.clone()
  ..tabNames = map['tabNames']??[]
  ..tabViewList = map['tabViewList']??[];
  return newState;
}
