import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/video_model.dart';

enum CommunityDetailAction { action , getAds ,getVideoModel, updateUI,pausePlay,startPlay,collect}

class CommunityDetailActionCreator {
  static Action onAction() {
    return  Action(CommunityDetailAction.action);
  }
  static Action updateUI() {
    return  Action(CommunityDetailAction.updateUI);
  }

  static Action onAds(List<AdsInfoBean> adsList) {
    return Action(CommunityDetailAction.getAds,payload: adsList);
  }

  static Action getVideoModel(VideoModel videoModel) {
    return Action(CommunityDetailAction.getVideoModel,payload: videoModel);
  }

  static Action pausePlay() {
    return Action(CommunityDetailAction.pausePlay);
  }

  static Action startPlay() {
    return Action(CommunityDetailAction.startPlay);
  }

  static Action operateCollect() {
    return const Action(CommunityDetailAction.collect);
  }
}
