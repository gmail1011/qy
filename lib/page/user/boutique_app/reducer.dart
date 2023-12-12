import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BoutiqueAppState> buildReducer() {
  return asReducer(
    <Object, Reducer<BoutiqueAppState>>{
      BoutiqueAppAction.updateUI: _updateUI,
    },
  );
}

BoutiqueAppState _updateUI(BoutiqueAppState state, Action action) {
  final BoutiqueAppState newState = state.clone();
  return newState;
}
