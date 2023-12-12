import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PayForNakeChatState> buildReducer() {
  return asReducer(
    <Object, Reducer<PayForNakeChatState>>{
      PayForAction.isPaying: _loading,
    },
  );
}

PayForNakeChatState _loading(PayForNakeChatState state, Action action) {
  final PayForNakeChatState newState = state.clone();
  newState.isPayLoading = action.payload;
  print("_loading-------------------------${newState.isPayLoading}");
  return newState;
}
