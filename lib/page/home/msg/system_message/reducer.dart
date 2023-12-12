import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SystemMessageState> buildReducer() {
  return asReducer(
    <Object, Reducer<SystemMessageState>>{
      SystemMessageAction.onLoadMessageAction: _onLoadSystemMessage,
    },
  );
}

SystemMessageState _onLoadSystemMessage(SystemMessageState state, Action action) {
  final SystemMessageState newState = state.clone();
  if(newState.messageModelList == null) {
    newState.messageModelList = [];
  }
  newState.messageModelList.addAll(action.payload['data']);
  newState.hasNext = action.payload['hasNext'];
  return newState;
}
