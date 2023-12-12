import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MyAgentState> buildReducer() {
  return asReducer(
    <Object, Reducer<MyAgentState>>{
      MyAgentAction.refreshData: _refreshData,
      MyAgentAction.getMarquee: _getMarquee,
    },
  );
}

MyAgentState _refreshData(MyAgentState state, Action action) {
  final MyAgentState newState = state.clone();
  newState.userIncomeModel = action.payload;
  return newState;
}

MyAgentState _getMarquee(MyAgentState state, Action action) {
  final MyAgentState newState = state.clone();
  newState.marquee = action.payload;
  return newState;
}
