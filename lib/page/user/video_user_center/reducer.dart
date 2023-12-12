import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'action.dart';
import 'state.dart';

Reducer<VideoUserCenterState> buildReducer() {
  return asReducer(
    <Object, Reducer<VideoUserCenterState>>{
      VideoUserCenterAction.updateUserInfo: _updateUserInfo,
      VideoUserCenterAction.showTopBtn: _showTopBtn,
      VideoUserCenterAction.refreshFollowStatus: _refreshFollowStatus,
      VideoUserCenterAction.showFollow: _showFollow,
      VideoUserCenterAction.initView: _initView,
    },
  );
}

VideoUserCenterState _initView(VideoUserCenterState state, Action action) {
  bool initUser = action.payload;
  if (initUser) {
    // 清空旧数据
    final VideoUserCenterState newState = VideoUserCenterState();
    newState.pageList = state.pageList;
    newState.scrollController = state.scrollController;
    newState.tabController = state.tabController;
    newState.uniqueID = state.uniqueID;
    newState.type = state.type;
    return newState;
  } else {
    return state.clone();
  }
}

VideoUserCenterState _updateUserInfo(
    VideoUserCenterState state, Action action) {
  final VideoUserCenterState newState = state.clone();
  newState.userInfoModel = action.payload;
  newState.picList = newState?.userInfoModel?.background ?? <String>[];
  newState.isFollowed = newState.userInfoModel.isFollow;
  if (!newState.isFollowed) {
    newState.showFollowBtn = true;
  }
  newState.tabTitle = [
    "${Lang.WORK_TEXT}${newState.userInfoModel.collectionCount}",
    //"${Lang.DYNAMIC_TEXT}${newState.userInfoModel.collectionCount}",
    "${Lang.SQUARE_TEXT}${newState.userInfoModel.happinessPlazaCount}",
    "${Lang.BUY_TEXT}${newState.userInfoModel.buyVidCount}",
    "${Lang.LIKE_TEXT}${newState.userInfoModel.likeCount}",
  ];
  return newState;
}

///刷新关注结果
VideoUserCenterState _refreshFollowStatus(
    VideoUserCenterState state, Action action) {
  final VideoUserCenterState newState = state.clone();
  newState.isFollowed = action.payload;
  newState.showFollowBtn = !newState.isFollowed;
  newState.userInfoModel.isFollow = action.payload;
  return newState;
}

VideoUserCenterState _showTopBtn(VideoUserCenterState state, Action action) {
  final VideoUserCenterState newState = state.clone();
  newState.showToTopBtn = action.payload;
  return newState;
}

///展示关注按钮
VideoUserCenterState _showFollow(VideoUserCenterState state, Action action) {
  final VideoUserCenterState newState = state.clone();
  newState.showFollowBtn = action.payload;
  return newState;
}
