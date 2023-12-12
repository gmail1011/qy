import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/manager/ad_Insert_manager.dart';
import 'package:flutter_app/model/ads_model.dart';

import 'action.dart';
import 'state.dart';

Reducer<HjllCommunityChildState> buildReducer() {
  return asReducer(
    <Object, Reducer<HjllCommunityChildState>>{
      HjllCommunityChildAction.setLoadData: _setLoadData,
      HjllCommunityChildAction.setVideoData: _setVideoData,
      HjllCommunityChildAction.setTagsData: _setTagsData,
      HjllCommunityChildAction.setLoadMoreData: _setLoadMoreData,
      HjllCommunityChildAction.getAdSuccess: _getAdSuccess,
      HjllCommunityChildAction.updateUI: _updateUI,
      HjllCommunityChildAction.checkProductBenefits: _checkProductBenefits,
      HjllCommunityChildAction.checkVipCutDownState: _checkVipCutDownState,
      HjllCommunityChildAction.setAnnouncementContent: _setAnnouncementContent
    },
  );
}

HjllCommunityChildState _setLoadData(
    HjllCommunityChildState state, Action action) {
  final HjllCommunityChildState newState = state.clone();
  newState.pageNumber = 1;
  newState.list = action.payload;
  AdInsertManager.insertVideoTabAd(newState.list);
  return newState;
}

HjllCommunityChildState _setVideoData(
    HjllCommunityChildState state, Action action) {
  final HjllCommunityChildState newState = state.clone();
  newState.pageNumber = 1;
  newState.videList = action.payload;
  AdInsertManager.insertTagAd(newState.videList);
  return newState;
}

HjllCommunityChildState _setTagsData(
    HjllCommunityChildState state, Action action) {
  final HjllCommunityChildState newState = state.clone();
  newState.allTags = action.payload;
  return newState;
}

HjllCommunityChildState _setLoadMoreData(
    HjllCommunityChildState state, Action action) {
  final HjllCommunityChildState newState = state.clone();
  newState.pageNumber++;
  newState.list.addAll(action.payload);
  AdInsertManager.insertVideoTabAd(newState.list);
  return newState;
}

HjllCommunityChildState _getAdSuccess(
    HjllCommunityChildState state, Action action) {
  final HjllCommunityChildState newState = state.clone();
  newState.adsList = action.payload as List<AdsInfoBean>;
  return newState;
}

HjllCommunityChildState _updateUI(
    HjllCommunityChildState state, Action action) {
  final HjllCommunityChildState newState = state.clone();
  return newState;
}

HjllCommunityChildState _checkProductBenefits(
    HjllCommunityChildState state, Action action) {
  final HjllCommunityChildState newState = state.clone();
  newState.productBenefits = Config.productBenefits ?? [];
  return newState;
}

HjllCommunityChildState _checkVipCutDownState(
    HjllCommunityChildState state, Action action) {
  final HjllCommunityChildState newState = state.clone();
  newState.cutDownState = action.payload;
  return newState;
}

HjllCommunityChildState _setAnnouncementContent(
    HjllCommunityChildState state, Action action) {
  final HjllCommunityChildState newState = state.clone();
  newState.announcementContent = action.payload;
  return newState;
}
