import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/film_tv_video/AllSection.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';

enum FilmTelevisionVideoAction {
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
  static Action loadData(int moduleSort) {
    return Action(FilmTelevisionVideoAction.loadData,payload: moduleSort);
  }

  static Action loadMoreData(int moduleSort) {
    return Action(FilmTelevisionVideoAction.loadMoreData,payload: moduleSort );
  }

  static Action getAdSuccess(List<AdsInfoBean> list) {
    return Action(FilmTelevisionVideoAction.getAdSuccess, payload: list);
  }

  static Action setLoadData(List<TagsDetailDataSections> list) {
    return Action(FilmTelevisionVideoAction.setLoadData, payload: list);
  }

  static Action setLoadVideoData(List<LiaoBaTagsDetailDataVideos>  videoList) {
    return Action(FilmTelevisionVideoAction.setVideoData, payload: videoList);
  }

  static Action setTagsData(List<AllSection>  videoList) {
    return Action(FilmTelevisionVideoAction.setTagsData, payload: videoList);
  }

  static Action setLoadMoreData(List<LiaoBaTagsDetailDataVideos>  videoList) {
    return Action(FilmTelevisionVideoAction.setLoadMoreData, payload: videoList);
  }

  static Action updateUI() {
    return Action(FilmTelevisionVideoAction.updateUI,);
  }

  static Action checkProductBenefits() {
    return const Action(FilmTelevisionVideoAction.checkProductBenefits);
  }

  static Action checkVipCutDownState(bool cutDownState) {
    return Action(FilmTelevisionVideoAction.checkVipCutDownState,
        payload: cutDownState);
  }

  static Action setAnnouncementContent(String announcementContent) {
    return Action(FilmTelevisionVideoAction.setAnnouncementContent,
        payload: announcementContent);
  }
}
