import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/res/common_post_res.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/guess_like_entity.dart';

enum CommunityRecommendAction {
  action,
  getAds,
  getData,
  onLoadMore,
  getAnnounce,
  getRecommendListAds,
  getChangeDataList,
  reqChangeDataList,
  doFollow,
  updateFollowState,
  checkFollowUser,
  getHotVideo,
}

class CommunityRecommendActionCreator {
  static Action onAction() {
    return const Action(CommunityRecommendAction.action);
  }

  static Action checkFollowUser(int uid, int changeDataIndex) {
    return Action(CommunityRecommendAction.checkFollowUser, payload: {
      "uid": uid,
      "changeDataIndex": changeDataIndex,
    });
  }

  static Action updateFollowState(int followUID, int changeDataIndex) {
    return Action(CommunityRecommendAction.updateFollowState, payload: {
      "followUID": followUID,
      "changeDataIndex": changeDataIndex,
    });
  }

  static Action doFollow(int changeDataIndex, int uid) {
    return Action(CommunityRecommendAction.doFollow,
        payload: {"uid": uid, "changeDataIndex": changeDataIndex});
  }

  static Action onAds(List<AdsInfoBean> adsList) {
    return Action(CommunityRecommendAction.getAds, payload: adsList);
  }

  static Action onRecommendListAds(List<AdsInfoBean> adsList) {
    return Action(CommunityRecommendAction.getRecommendListAds,
        payload: adsList);
  }

  static Action onGetData(CommonPostRes commonPostRes) {
    return Action(CommunityRecommendAction.getData, payload: commonPostRes);
  }

  static Action onLoadMore(int pageNum) {
    return Action(CommunityRecommendAction.onLoadMore, payload: pageNum);
  }

  static Action onGetAnnounce(String announce) {
    return Action(CommunityRecommendAction.getAnnounce, payload: announce);
  }

  static Action getChangeDataListByIndex(int changeIndex) {
    return Action(CommunityRecommendAction.reqChangeDataList,
        payload: changeIndex);
  }

  static Action onChangeDataList(
      List<GuessLikeDataList> dataList, int changeIndex) {
    return Action(CommunityRecommendAction.getChangeDataList, payload: {
      changeIndex: dataList,
    });
  }


  static Action onGetHotVideo(CommonPostRes commonPostRes) {
    return Action(CommunityRecommendAction.getHotVideo, payload: commonPostRes);
  }
}
