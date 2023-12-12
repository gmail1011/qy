import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';

enum FilmVideoIntroductionAction {
  updateUI,
  refreshData,
  loadMoreData,
  like,
  collect,
  changeLine,
  cacheVideo,
  reloadNewVideo,
  notifyNewVideo,
  stopVideoPlay,
  notifyBuyVideo,
  notifyReStartPlayVideo,
  doFollow,
  updateFollowState,
}

class FilmVideoIntroductionActionCreator {
  static Action updateUI() {
    return const Action(FilmVideoIntroductionAction.updateUI);
  }

  static Action refreshData() {
    return const Action(FilmVideoIntroductionAction.refreshData);
  }

  static Action loadMoreData() {
    return const Action(FilmVideoIntroductionAction.loadMoreData);
  }

  static Action operateLike() {
    return const Action(FilmVideoIntroductionAction.like);
  }

  static Action operateCollect() {
    return const Action(FilmVideoIntroductionAction.collect);
  }

  static Action cacheVideo() {
    return const Action(FilmVideoIntroductionAction.cacheVideo);
  }

  static Action changeLine() {
    return const Action(FilmVideoIntroductionAction.changeLine);
  }

  static Action reloadNewVideo(VideoModel videoItem) {
    return Action(FilmVideoIntroductionAction.reloadNewVideo,
        payload: videoItem);
  }

  ///通知替换新视频
  static Action notifyNewVideo(VideoModel videoItem) {
    return Action(FilmVideoIntroductionAction.notifyNewVideo,
        payload: videoItem);
  }

  ///通知通知播放视频
  static Action stopVideoPlay(String videoId) {
    return Action(FilmVideoIntroductionAction.stopVideoPlay, payload: videoId);
  }

  ///通知通知播放视频
  static Action notifyBuyVideo(String videoId) {
    return Action(FilmVideoIntroductionAction.notifyBuyVideo, payload: videoId);
  }

  ///通知重新播放视频
  static Action notifyReStartPlayVideo(String videoId) {
    return Action(FilmVideoIntroductionAction.notifyReStartPlayVideo,
        payload: videoId);
  }

  ///执行关注
  static Action doFollow(int followUID) {
    return Action(FilmVideoIntroductionAction.doFollow, payload: followUID);
  }

  static Action updateFollowState(bool isFollow) {
    return Action(FilmVideoIntroductionAction.updateFollowState,
        payload: isFollow);
  }
}
