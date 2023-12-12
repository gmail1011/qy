import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/index/action.dart';

import 'state.dart';

Reducer<IndexState> buildReducer() {
  return asReducer(
    <Object, Reducer<IndexState>>{
      IndexAction.changeIndex: _changeIndex,
    },
  );
}

IndexState _changeIndex(IndexState state, Action action) {
  final IndexState newState = state.clone()..currentIndex = action.payload;
  return newState;
}
