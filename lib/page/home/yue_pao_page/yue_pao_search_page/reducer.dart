import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<YuePaoSearchState> buildReducer() {
  return asReducer(
    <Object, Reducer<YuePaoSearchState>>{
      YuePaoSearchAction.onInitList: _onInitList,
      YuePaoSearchAction.onAddList: _onAddList,
      YuePaoSearchAction.onChangePageNumber: _onChangePageNumber,
      YuePaoSearchAction.onChangeItem: _onChangeItem,
    },
  );
}
YuePaoSearchState _onChangeItem(YuePaoSearchState state, Action action) {
  var louFengItem = action.payload;
  final YuePaoSearchState newState = state.clone();
  var louFengList = newState.louFengList;
  louFengList.map((item) {
    if(item.id == louFengItem.id){
      return louFengItem;
    }
    return item;
  });
  return newState;
}

YuePaoSearchState _onInitList(YuePaoSearchState state, Action action) {
  final YuePaoSearchState newState = state.clone()
  ..pageNumber = 1
  ..louFengList = action.payload;
  return newState;
}

YuePaoSearchState _onAddList(YuePaoSearchState state, Action action) {
  final YuePaoSearchState newState = state.clone()
  ..louFengList.addAll(action.payload);
  return newState;
}
YuePaoSearchState _onChangePageNumber(YuePaoSearchState state, Action action) {
  final YuePaoSearchState newState = state.clone()
  ..pageNumber = state.pageNumber+1;
  return newState;
}