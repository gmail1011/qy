import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AudiobookDataListState> buildReducer() {
  return asReducer(
    <Object, Reducer<AudiobookDataListState>>{
      AudiobookDataListAction.setLoadData: _loadData,
      AudiobookDataListAction.setLoadMoreData: _loadMoreData,
    },
  );
}

AudiobookDataListState _loadData(AudiobookDataListState state, Action action) {
  final AudiobookDataListState newState = state.clone();
  newState.list = action.payload;
  newState.pageNumber = 1;

  return newState;
}

AudiobookDataListState _loadMoreData(
    AudiobookDataListState state, Action action) {
  final AudiobookDataListState newState = state.clone();
  newState.list.addAll(action.payload);
  newState.pageNumber++;
  return newState;
}
