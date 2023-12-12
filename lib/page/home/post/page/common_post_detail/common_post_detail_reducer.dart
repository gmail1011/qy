import 'package:fish_redux/fish_redux.dart';

import 'common_post_detail_action.dart';
import 'common_post_detail_state.dart';

Reducer<CommonPostDetailState> buildReducer() {
  return asReducer(
    <Object, Reducer<CommonPostDetailState>>{
      CommonPostDetailAction.action: _onAction,
      CommonPostDetailAction.getTags: _getTags,
      CommonPostDetailAction.getDetails: _onGetDetails,
      CommonPostDetailAction.loadmore: _onLoadMore,
      CommonPostDetailAction.setLoading: _onSetLoading,
    },
  );
}

CommonPostDetailState _onAction(CommonPostDetailState state, Action action) {
  final CommonPostDetailState newState = state.clone();
  return newState;
}


CommonPostDetailState _getTags(CommonPostDetailState state, Action action) {
  final CommonPostDetailState newState = state.clone();
  newState.specialModel = action.payload;
  newState.specialModel.tags.forEach((element) {
    newState.tagsOptions.add(element.tagName);
  });

  return newState;
}

CommonPostDetailState _onGetDetails(CommonPostDetailState state, Action action) {
  final CommonPostDetailState newState = state.clone();
  newState.selectedTagsData = action.payload;
  return newState;
}

CommonPostDetailState _onLoadMore(CommonPostDetailState state, Action action) {
  final CommonPostDetailState newState = state.clone();
  newState.selectedTagsBean = action.payload;
  return newState;
}

CommonPostDetailState _onSetLoading(CommonPostDetailState state, Action action) {
  final CommonPostDetailState newState = state.clone();
  newState.isLoading = action.payload;
  return newState;
}
