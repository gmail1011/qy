import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
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
      CommonPostAction.onLoadMore: _loadMoreData,
      CommonPostAction.getDailyData: _getDailyData,
      CommonPostAction.getDailyDataLoadMore: _getDailyDataLoadMore,
    },
  );
}

CommonPostState _refreshFollowStatus(CommonPostState state, Action action) {
  CommonPostState newState = state.clone();
  return newState;
}

CommonPostState _initListSuccess(CommonPostState state, Action action) {
  final List<TagsDetailDataSections> list = action.payload ?? <TagsDetailDataSections>[];
  final CommonPostState newState = state.clone();
  newState.specialModels = list;
  newState.pageNumber = 1;
  return newState;
}

CommonPostState _loadMoreSuccess(CommonPostState state, Action action) {
  /*final CommonPostState newState = state.clone();
  newState.dayItems.addAll(action.payload ?? []);
  newState.pageNumber++;*/

  final CommonPostState newState = state.clone();
  //newState.pageNumber ++ ;
  //newState.specialModels.addAll(action.payload);

  newState.specialModels = action.payload;

  return newState;
}


CommonPostState _getAdsSuccess(CommonPostState state, Action action) {
  final CommonPostState newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}

CommonPostState _loadMoreData(CommonPostState state, Action action) {
  final CommonPostState newState = state.clone();
  newState.pageNumber = action.payload;
  return newState;
}

CommonPostState _getDailyData(CommonPostState state, Action action) {
  final CommonPostState newState = state.clone();
  newState.selectedTagsData = action.payload;
  return newState;
}

CommonPostState _getDailyDataLoadMore(CommonPostState state, Action action) {
  final CommonPostState newState = state.clone();
  newState.dailyDataPageNum = action.payload;
  return newState;
}
