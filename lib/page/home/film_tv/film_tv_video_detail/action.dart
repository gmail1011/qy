import 'package:fish_redux/fish_redux.dart';

enum FilmTvVideoDetailAction {
  updateUI,
  refreshVideoDetail,
  updateVideoStatus,
  upddateCurrentPlayDuration,
  setStopVideoState,
  onCountDownTime,
  closeAd,
  hjllBuyVIP,
  hjllBuyCoinVideo,
}

class FilmTvVideoDetailActionCreator {
  static Action updateUI() {
    return const Action(FilmTvVideoDetailAction.updateUI);
  }

  static Action refreshVideoDetail() {
    return const Action(FilmTvVideoDetailAction.refreshVideoDetail);
  }
  static Action closeAd() {
    return const Action(FilmTvVideoDetailAction.closeAd);
  }
  static Action updateVideoStatus(int status) {
    return Action(FilmTvVideoDetailAction.updateVideoStatus, payload: status);
  }

  static Action upddateCurrentPlayDuration(int videoCurrentDuration) {
    return Action(FilmTvVideoDetailAction.upddateCurrentPlayDuration,
        payload: videoCurrentDuration);
  }

  static Action setStopVideoState() {
    return const Action(FilmTvVideoDetailAction.setStopVideoState);
  }

  /// 倒计时
  static Action onCountDownTime(int time) {
    return Action(FilmTvVideoDetailAction.onCountDownTime, payload: time);
  }

  static Action hjllBuyVIP() {
    return Action(FilmTvVideoDetailAction.hjllBuyVIP);
  }

  static Action hjllBuyCoinVideo() {
    return Action(FilmTvVideoDetailAction.hjllBuyCoinVideo);
  }


}
