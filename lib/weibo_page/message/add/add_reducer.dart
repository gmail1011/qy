import 'package:fish_redux/fish_redux.dart';

import 'add_action.dart';
import 'add_state.dart';

Reducer<AddState> buildReducer() {
  return asReducer(
    <Object, Reducer<AddState>>{
      AddAction.action: _onAction,
      AddAction.getData: getData,
      AddAction.onLoadMore: onLoadMore,
      AddAction.onUserLoadMore: onUserLoadMore,
      AddAction.getUserData: getUserData,
      AddAction.setSearchUser: setSearchUser,
    },
  );
}

AddState _onAction(AddState state, Action action) {
  final AddState newState = state.clone();
  return newState;
}

AddState getData(AddState state, Action action) {
  final AddState newState = state.clone();
  newState.fansObj = action.payload;
  return newState;
}

AddState onLoadMore(AddState state, Action action) {
  final AddState newState = state.clone();
  newState.pageNumber = action.payload;
  return newState;
}

AddState onUserLoadMore(AddState state, Action action) {
  final AddState newState = state.clone();
  newState.isSearchUser = true;
  newState.userPageNum = action.payload;
  return newState;
}

AddState getUserData(AddState state, Action action) {
  final AddState newState = state.clone();
  newState.searchBeanData = action.payload;
  return newState;
}

AddState setSearchUser(AddState state, Action action) {
  final AddState newState = state.clone();
  newState.isSearchUser = action.payload;
  return newState;
}
