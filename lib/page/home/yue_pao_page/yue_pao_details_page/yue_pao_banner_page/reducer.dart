import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<YuePaoBannerState> buildReducer() {
  return asReducer(
    <Object, Reducer<YuePaoBannerState>>{
      YuePaoBannerAction.action: _onAction,
    },
  );
}

YuePaoBannerState _onAction(YuePaoBannerState state, Action action) {
  final YuePaoBannerState newState = state.clone();
  return newState;
}
