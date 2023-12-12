import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<YuePaoDetailsState> buildReducer() {
  return asReducer(
    <Object, Reducer<YuePaoDetailsState>>{
      YuePaoDetailsAction.changeItem: _onChangeItem,
      YuePaoDetailsAction.onChangeCountBrowse: _onChangeCountBrowse,
      YuePaoDetailsAction.onChangeList: _onChangeList,
      YuePaoDetailsAction.onChangePageNumber: _onChangePageNumber,
      YuePaoDetailsAction.onReplaceLouFengItem: _onReplaceLouFengItem,
      YuePaoDetailsAction.initPageNumber: _initPageNumber,
      YuePaoDetailsAction.productItemBean: _productItemBean,
    },
  );
}

YuePaoDetailsState _productItemBean(YuePaoDetailsState state, Action action) {
  final YuePaoDetailsState newState = state.clone()
    ..productItemBean = action.payload;
  return newState;
}

YuePaoDetailsState _initPageNumber(YuePaoDetailsState state, Action action) {
  final YuePaoDetailsState newState = state.clone()..pageNumber = 1;
  return newState;
}

YuePaoDetailsState _onReplaceLouFengItem(
    YuePaoDetailsState state, Action action) {
  final YuePaoDetailsState newState = state.clone()
    ..list = []
    ..louFengItem = action.payload;
  return newState;
}

YuePaoDetailsState _onChangeCountBrowse(
    YuePaoDetailsState state, Action action) {
  final YuePaoDetailsState newState = state.clone()
    ..louFengItem.countBrowse += 1;
  return newState;
}

YuePaoDetailsState _onChangeItem(YuePaoDetailsState state, Action action) {
  var isCollect = action.payload;
  final YuePaoDetailsState newState = state.clone()
    ..louFengItem.isCollect = isCollect;
  if (isCollect) {
    newState.louFengItem.countCollect++;
  } else {
    newState.louFengItem.countCollect--;
  }
  return newState;
}

YuePaoDetailsState _onChangePageNumber(
    YuePaoDetailsState state, Action action) {
  final YuePaoDetailsState newState = state.clone()..pageNumber += 1;
  return newState;
}

YuePaoDetailsState _onChangeList(YuePaoDetailsState state, Action action) {
  final YuePaoDetailsState newState = state.clone()
    ..list.addAll(action.payload ?? []);
  return newState;
}
