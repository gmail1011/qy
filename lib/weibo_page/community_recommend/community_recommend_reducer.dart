import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_base/utils/log.dart';

import 'community_recommend_action.dart';
import 'community_recommend_state.dart';

Reducer<CommunityRecommendState> buildReducer() {
  return asReducer(
    <Object, Reducer<CommunityRecommendState>>{
      CommunityRecommendAction.action: _onAction,
      CommunityRecommendAction.getAds: _onGetAds,
      CommunityRecommendAction.getData: _onGetData,
      CommunityRecommendAction.getHotVideo: _onGetHotVideo,
      CommunityRecommendAction.onLoadMore: _onLoadMore,
      CommunityRecommendAction.getAnnounce: _onGetAnnounce,
      CommunityRecommendAction.getRecommendListAds: _getRecommendListAds,
      CommunityRecommendAction.getChangeDataList: _getChangeDataList,
      CommunityRecommendAction.updateFollowState: _updateFollowState,
    },
  );
}

///添加换一换数据
CommunityRecommendState _getChangeDataList(
    CommunityRecommendState state, Action action) {
  final CommunityRecommendState newState = state.clone();
  Map map = action.payload as Map;
  map?.keys?.forEach((element) {
    if (newState.changeDataListMap.containsKey(element)) {
      newState.changeDataListMap?.remove(element);
    }
  });
  newState.changeDataListMap?.addAll(map);
  return newState;
}


CommunityRecommendState _onAction(
    CommunityRecommendState state, Action action) {
  final CommunityRecommendState newState = state.clone();
  return newState;
}

CommunityRecommendState _onGetAds(
    CommunityRecommendState state, Action action) {
  final CommunityRecommendState newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}

CommunityRecommendState _getRecommendListAds(
    CommunityRecommendState state, Action action) {
  final CommunityRecommendState newState = state.clone();
  newState.recommendListAdsList = action.payload;
  return newState;
}

CommunityRecommendState _onGetData(
    CommunityRecommendState state, Action action) {
  final CommunityRecommendState newState = state.clone();
  newState.commonPostRes = action.payload;
  return newState;
}

CommunityRecommendState _onGetHotVideo(
    CommunityRecommendState state, Action action) {
  final CommunityRecommendState newState = state.clone();
  newState.commonPostResHotVideo = action.payload;
  return newState;
}

CommunityRecommendState _onLoadMore(
    CommunityRecommendState state, Action action) {
  final CommunityRecommendState newState = state.clone();
  newState.pageNumber = action.payload;
  return newState;
}

CommunityRecommendState _onGetAnnounce(
    CommunityRecommendState state, Action action) {
  final CommunityRecommendState newState = state.clone();
  newState.announce = action.payload;
  return newState;
}

///更新关注状态
CommunityRecommendState _updateFollowState(
    CommunityRecommendState state, Action action) {
  final CommunityRecommendState newState = state.clone();

  try {
    Map map = action.payload as Map;
    int followUID = map["followUID"];
    int changeDataIndex = map["changeDataIndex"];

    if (newState.changeDataListMap != null &&
        newState.changeDataListMap.containsKey(changeDataIndex)) {
      newState.changeDataListMap[changeDataIndex]?.forEach((element) {
        if (followUID == element.uid) {
          element.hasFollow = true;
        }
      });
    }
    l.d("更新关注人UI", "成功");
  } catch (e) {
    l.d("更新关注人UI", "$e");
  }
  return newState;
}
