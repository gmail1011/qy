import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/film_tv_video/AllSection.dart';
import 'package:flutter_app/model/film_tv_video/AllTags.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';

enum HjllCommunityChildAction {
  loadData,
  loadMoreData,
  getAdSuccess,
  setLoadData,
  setVideoData,
  setTagsData,
  setLoadMoreData,
  updateUI,
  checkProductBenefits,
  checkVipCutDownState,
  setAnnouncementContent,
}

class FilmTelevisionVideoActionCreator {
  static Action loadData() {
    return const Action(HjllCommunityChildAction.loadData);
  }

  static Action loadMoreData() {
    return const Action(HjllCommunityChildAction.loadMoreData);
  }

  static Action getAdSuccess(List<AdsInfoBean> list) {
    return Action(HjllCommunityChildAction.getAdSuccess, payload: list);
  }

  static Action setLoadData(List<TagsDetailDataSections> list) {
    return Action(HjllCommunityChildAction.setLoadData, payload: list);
  }

  static Action setLoadVideoData(List<LiaoBaTagsDetailDataVideos>  videoList) {
    return Action(HjllCommunityChildAction.setVideoData, payload: videoList);
  }

  static Action setTagsData( List<AllTags> allTags) {
    return Action(HjllCommunityChildAction.setTagsData, payload: allTags);
  }

  static Action setLoadMoreData(List<TagsDetailDataSections> list) {
    return Action(HjllCommunityChildAction.setLoadMoreData, payload: list);
  }

  static Action updateUI() {
    return const Action(HjllCommunityChildAction.updateUI);
  }

  static Action checkProductBenefits() {
    return const Action(HjllCommunityChildAction.checkProductBenefits);
  }

  static Action checkVipCutDownState(bool cutDownState) {
    return Action(HjllCommunityChildAction.checkVipCutDownState,
        payload: cutDownState);
  }

  static Action setAnnouncementContent(String announcementContent) {
    return Action(HjllCommunityChildAction.setAnnouncementContent,
        payload: announcementContent);
  }
}
