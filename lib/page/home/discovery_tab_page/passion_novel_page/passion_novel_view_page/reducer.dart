import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/novel_model.dart';

import 'action.dart';
import 'state.dart';

Reducer<PassionNovelViewState> buildReducer() {
  return asReducer(
    <Object, Reducer<PassionNovelViewState>>{
      PassionNovelViewAction.onChangeList: _onChangeList,
      PassionNovelViewAction.onChangePageNumber: _onChangePageNumber,
      PassionNovelViewAction.initPageNumber: _initPageNumber,
      PassionNovelViewAction.onSetKeyWord: _onSetKeyWord,
      PassionNovelViewAction.replaceItem: _replaceItem,
    },
  );
}

PassionNovelViewState _replaceItem(PassionNovelViewState state, Action action) {
  var newItem = action.payload;
  final PassionNovelViewState newState = state.clone();
  List<NoveItem> list = newState.list;
  newState.list = list.map<NoveItem>((item) {
    if (item.id == newItem.id) {
      return newItem;
    }
    return item;
  }).toList();
  return newState;
}

PassionNovelViewState _onSetKeyWord(
    PassionNovelViewState state, Action action) {
  final PassionNovelViewState newState = state.clone()
    ..keyword = action.payload ?? '';
  return newState;
}

PassionNovelViewState _onChangeList(
    PassionNovelViewState state, Action action) {
  int pageNumber = state.pageNumber;
  final PassionNovelViewState newState = state.clone();
  if (pageNumber == 1) {
    newState.list = action.payload ?? [];
  } else {
    newState.list.addAll(action.payload);
  }
  return newState;
}

PassionNovelViewState _onChangePageNumber(
    PassionNovelViewState state, Action action) {
  final PassionNovelViewState newState = state.clone()..pageNumber += 1;
  return newState;
}

PassionNovelViewState _initPageNumber(
    PassionNovelViewState state, Action action) {
  final PassionNovelViewState newState = state.clone()..pageNumber = 1;
  return newState;
}
