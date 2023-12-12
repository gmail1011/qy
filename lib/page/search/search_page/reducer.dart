import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';

import 'action.dart';
import 'state.dart';

Reducer<SearchState> buildReducer() {
  return asReducer(
    <Object, Reducer<SearchState>>{
      SearchAction.showAll: _showAll,
      SearchAction.refreshHistorys: _refreshHistorys,
      SearchAction.refreshTag: _refreshTag,
      SearchAction.getHotSearchList: _getHotList,
      SearchAction.getHotSearchBlogger: _getHotBlogger,
      SearchAction.getAdList:getAdList,
      SearchAction.updateUI:_updateUI
    },
  );
}

SearchState _showAll(SearchState state, Action action) {
  var newState = state.clone();
  newState.showAll = !newState.showAll;
  return newState;
}

SearchState _refreshHistorys(SearchState state, Action action) {
  var newState = state.clone();
  var list = action.payload as List<String>;
  newState.searchHistorys = list;
  return newState;
}

SearchState _refreshTag(SearchState state, Action action) {
  var newState = state.clone();
  var list = action.payload as List<TagDetailModel>;
  newState.tagList = list;
  return newState;
}

SearchState _getHotList(SearchState state, Action action) {
  var newState = state.clone();
  newState.searchDefaultData = action.payload;
  return newState;
}

SearchState _getHotBlogger(SearchState state, Action action) {
  var newState = state.clone();
  newState.searchDefaultHotBloggerData = action.payload;
  return newState;
}

SearchState getAdList(SearchState state, Action action) {
  var newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}



SearchState _updateUI(SearchState state, Action action) {
  final SearchState newState = state.clone();
  return newState;
}
