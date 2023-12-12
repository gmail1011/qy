import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

import 'action.dart';
import 'state.dart';

Reducer<AudiobookMoreState> buildReducer() {
  return asReducer(
    <Object, Reducer<AudiobookMoreState>>{
      AudiobookMoreAction.setTabs: _onAction,
    },
  );
}

AudiobookMoreState _onAction(AudiobookMoreState state, Action action) {
  final AudiobookMoreState newState = state.clone();
  newState.typeTabs = action.payload;
  newState.tabController = TabController(
    length: newState.typeTabs?.length ?? 0,
    vsync: ScrollableState(),
  );
  return newState;
}
