import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<VoiceAnchorDataListState> buildReducer() {
  return asReducer(
    <Object, Reducer<VoiceAnchorDataListState>>{
      VoiceAnchorDataListAction.setLoadData: _loadData,
      VoiceAnchorDataListAction.setLoadMoreData: _loadMoreData,
    },
  );
}

VoiceAnchorDataListState _loadData(
    VoiceAnchorDataListState state, Action action) {
  final VoiceAnchorDataListState newState = state.clone();
  newState.list = action.payload;
  newState.pageNumber = 1;

  return newState;
}

VoiceAnchorDataListState _loadMoreData(
    VoiceAnchorDataListState state, Action action) {
  final VoiceAnchorDataListState newState = state.clone();
  newState.list.addAll(action.payload);
  newState.pageNumber++;
  return newState;
}
