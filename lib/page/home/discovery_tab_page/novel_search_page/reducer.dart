import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<NovelSearchState> buildReducer() {
  return asReducer(
    <Object, Reducer<NovelSearchState>>{
      NovelSearchAction.showAll: _showAll,
      NovelSearchAction.refreshHistorys: _refreshHistorys,
      NovelSearchAction.onChangeNovelList: _onChangeNovelList,
      NovelSearchAction.onChangeAudioBookList: _onChangeAudioBookList,
      NovelSearchAction.onChangePageNumber: _onChangePageNumber,
      NovelSearchAction.initPageNumber: _initPageNumber,
    },
  );
}

NovelSearchState _initPageNumber(NovelSearchState state, Action action) {
  var newState = state.clone()
  ..pageNumber = 1;
  return newState;
}
NovelSearchState _showAll(NovelSearchState state, Action action) {
  var newState = state.clone();
  newState.showAll = !newState.showAll;
  return newState;
}

NovelSearchState _onChangePageNumber(NovelSearchState state, Action action) {
  var newState = state.clone()
  ..pageNumber+=1;
  return newState;
}

NovelSearchState _onChangeAudioBookList(NovelSearchState state, Action action) {
  int pageNumber = state.pageNumber;
  var newState = state.clone();
  if (pageNumber == 1) {
    newState.audioList = action.payload ?? [];
  } else {
    newState.audioList.addAll(action.payload);
  }
  return newState;
}

NovelSearchState _onChangeNovelList(NovelSearchState state, Action action) {
  int pageNumber = state.pageNumber;
  var newState = state.clone();
  if (pageNumber == 1) {
    newState.list = action.payload ?? [];
  } else {
    newState.list.addAll(action.payload);
  }
  return newState;
}

NovelSearchState _refreshHistorys(NovelSearchState state, Action action) {
  var newState = state.clone();
  var list = action.payload as List<String>;
  newState.searchHistorys = list;
  return newState;
}
