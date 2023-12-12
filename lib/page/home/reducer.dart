import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HomeState> buildReducer() {
  return asReducer(
    <Object, Reducer<HomeState>>{
      HomeAction.changeTabOkay: _changeTabOkay,
    },
  );
}

HomeState _changeTabOkay(HomeState state, Action action) {
  return state.clone()..currentIndex = action.payload;
}
