import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';

import 'action.dart';
import 'state.dart';

Reducer<CommonPostTagsState> buildReducer() {
  return asReducer(
    <Object, Reducer<CommonPostTagsState>>{
      CommonPostAction.initListSuccess: _initListSuccess,
      //CommonPostAction.loadMoreSuccess: _loadMoreSuccess,
      CommonPostAction.refreshFollowStatus: _refreshFollowStatus,
      CommonPostAction.getAdsSuccess: _getAdsSuccess,
      CommonPostAction.onLoadMore: _loadMore,
      CommonPostAction.selectBean: _selectedBean,
      CommonPostAction.selectDataDetail: _selectedDataDetail,
      CommonPostAction.setLoading: _setLoading,
      CommonPostAction.getDailyData: _setLoading,
      //CommonPostAction.setLoadMoreData: _loadMoreData,
    },
  );
}

CommonPostTagsState _refreshFollowStatus(CommonPostTagsState state, Action action) {
  CommonPostTagsState newState = state.clone();
  return newState;
}

CommonPostTagsState _initListSuccess(CommonPostTagsState state, Action action) {
  final CommonPostTagsState newState = state.clone();
  newState.tagsDetails = action.payload;
  newState.pageNumber = 1;
  return newState;
}

CommonPostTagsState _loadMore(CommonPostTagsState state, Action action) {
  /*final CommonPostState newState = state.clone();
  newState.dayItems.addAll(action.payload ?? []);
  newState.pageNumber++;*/

  final CommonPostTagsState newState = state.clone();
 // newState.pageNumber++;
  //newState.tagsDetails.addAll(action.payload);

  return newState;
}


CommonPostTagsState _getAdsSuccess(CommonPostTagsState state, Action action) {
  final CommonPostTagsState newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}

CommonPostTagsState _loadMoreData(CommonPostTagsState state, Action action) {
  final CommonPostTagsState newState = state.clone();
  newState.pageNumber++;
  newState.tagsDetails.addAll(action.payload);
  return newState;
}


CommonPostTagsState _selectedBean(CommonPostTagsState state, Action action) {
  final CommonPostTagsState newState = state.clone();
  newState.selectedBean = action.payload;
  return newState;
}

CommonPostTagsState _selectedDataDetail(CommonPostTagsState state, Action action) {
  final CommonPostTagsState newState = state.clone();
  newState.selectedTagsData = action.payload;
  return newState;
}

CommonPostTagsState _setLoading(CommonPostTagsState state, Action action) {
  final CommonPostTagsState newState = state.clone();
  newState.isLoading = action.payload;
  return newState;
}
