import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/manager/ad_Insert_manager.dart';
import 'package:flutter_app/model/ads_model.dart';

import 'action.dart';
import 'state.dart';

Reducer<FilmTelevisionVideoState> buildReducer() {
  return asReducer(
    <Object, Reducer<FilmTelevisionVideoState>>{
      FilmTelevisionVideoAction.setLoadData: _setLoadData,
      FilmTelevisionVideoAction.setVideoData: _setVideoData,
      FilmTelevisionVideoAction.setTagsData: _setTagsData,
      FilmTelevisionVideoAction.setLoadMoreData: _setLoadMoreData,
      FilmTelevisionVideoAction.getAdSuccess: _getAdSuccess,
      FilmTelevisionVideoAction.updateUI: _updateUI,
      FilmTelevisionVideoAction.checkProductBenefits: _checkProductBenefits,
      FilmTelevisionVideoAction.checkVipCutDownState: _checkVipCutDownState,
      FilmTelevisionVideoAction.setAnnouncementContent: _setAnnouncementContent,

      FilmTelevisionVideoAction.loadData: _onTapIndex,
    },
  );
}

FilmTelevisionVideoState _setLoadData(
    FilmTelevisionVideoState state, Action action) {
  final FilmTelevisionVideoState newState = state.clone();
  newState.pageNumber = 1;
  newState.list = action.payload;
  AdInsertManager.insertVideoTabAd(newState.list);
  return newState;
}

FilmTelevisionVideoState _setVideoData(
    FilmTelevisionVideoState state, Action action) {
  final FilmTelevisionVideoState newState = state.clone();
  newState.pageNumber = 1;
  newState.videList = action.payload;
  AdInsertManager.insertHomeVideoAd(newState.videList, adArr: newState.adsList);
  return newState;
}

FilmTelevisionVideoState _setTagsData(
    FilmTelevisionVideoState state, Action action) {
  final FilmTelevisionVideoState newState = state.clone();
  newState.allSection = action.payload;
  return newState;
}

FilmTelevisionVideoState _setLoadMoreData(
    FilmTelevisionVideoState state, Action action) {
  final FilmTelevisionVideoState newState = state.clone();
  newState.pageNumber++;
  newState.videList.addAll(action.payload);
  AdInsertManager.insertHomeVideoAd(newState.videList, adArr: newState.adsList);
  return newState;
}

FilmTelevisionVideoState _getAdSuccess(
    FilmTelevisionVideoState state, Action action) {
  final FilmTelevisionVideoState newState = state.clone();
  newState.adsList = action.payload as List<AdsInfoBean>;
  return newState;
}

FilmTelevisionVideoState _updateUI(
    FilmTelevisionVideoState state, Action action) {
  final FilmTelevisionVideoState newState = state.clone();
  return newState;
}

FilmTelevisionVideoState _checkProductBenefits(
    FilmTelevisionVideoState state, Action action) {
  final FilmTelevisionVideoState newState = state.clone();
  newState.productBenefits = Config.productBenefits ?? [];
  return newState;
}

FilmTelevisionVideoState _checkVipCutDownState(
    FilmTelevisionVideoState state, Action action) {
  final FilmTelevisionVideoState newState = state.clone();
  newState.cutDownState = action.payload;
  return newState;
}

FilmTelevisionVideoState _setAnnouncementContent(
    FilmTelevisionVideoState state, Action action) {
  final FilmTelevisionVideoState newState = state.clone();
  newState.announcementContent = action.payload;
  return newState;
}


FilmTelevisionVideoState _onTapIndex(
    FilmTelevisionVideoState state, Action action) {
  final FilmTelevisionVideoState newState = state.clone();
  newState.moduleSort = action.payload;
  return newState;
}
