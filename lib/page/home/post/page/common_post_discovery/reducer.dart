import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';

import 'action.dart';
import 'state.dart';

Reducer<CommonPostState> buildReducer() {
  return asReducer(
    <Object, Reducer<CommonPostState>>{
      CommonPostAction.initListSuccess: _initListSuccess,
      CommonPostAction.loadMoreSuccess: _loadMoreSuccess,
      CommonPostAction.refreshFollowStatus: _refreshFollowStatus,
      CommonPostAction.getAdsSuccess: _getAdsSuccess,
      CommonPostAction.getTags: _getTags,
      CommonPostAction.getTagDetailList: _getTagsDetailList,
      CommonPostAction.onTagClick: _onTagClick,
      CommonPostAction.onLoadMore: _loadMoreData,
    },
  );
}

CommonPostState _refreshFollowStatus(CommonPostState state, Action action) {
  CommonPostState newState = state.clone();
  return newState;
}

CommonPostState _initListSuccess(CommonPostState state, Action action) {
  final List<PostItemState> list = action.payload ?? <PostItemState>[];
  final CommonPostState newState = state.clone();
  newState.dayItems = list;
  newState.pageNumber = 1;
  return newState;
}

CommonPostState _loadMoreSuccess(CommonPostState state, Action action) {
  /*final CommonPostState newState = state.clone();
  newState.dayItems.addAll(action.payload ?? []);
  newState.pageNumber++;*/

  final CommonPostState newState = state.clone();
  newState.pageNumber++;
  newState.list.addAll(action.payload);

  return newState;
}


CommonPostState _getAdsSuccess(CommonPostState state, Action action) {
  final CommonPostState newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}

CommonPostState _loadMoreData(CommonPostState state, Action action) {
  final CommonPostState newState = state.clone();
  //newState.pageNumber++;
  //newState.list.addAll(action.payload);
  newState.tageBean = action.payload;
  return newState;
}


CommonPostState _getTags(CommonPostState state, Action action) {
  final CommonPostState newState = state.clone();
  newState.tags = action.payload;
  return newState;
}

CommonPostState _getTagsDetailList(CommonPostState state, Action action) {
  final CommonPostState newState = state.clone();
  newState.tagDetailList = action.payload;
  return newState;
}

CommonPostState _onTagClick(CommonPostState state, Action action) {
  final CommonPostState newState = state.clone();
  newState.tagIndex = action.payload;
  return newState;
}
