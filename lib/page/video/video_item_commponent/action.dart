import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/widget/chewie/chewie_player.dart';
import 'package:flutter_base/player/ijk_base_video_controler.dart';

enum VideoItemAction {
  onVideoClick,
  onVideoDoubleClick,
  onVideoUpdate,
  onVideoRefresh,
  onVideoInited,

  onClickCity,
  onBuyProduct,
  buyProductSuccess,
  onClickComment,
  commentSuccess,
  onShowShare,
  onShowVipDialog,
  onFollow,
  onTapTag,
  onLove,
  onUser,
  refreshFollowStatus,
  refreshUI,
  onDownloadImg,
  onDownloadVideo,
  cacheVideo,
  refresh,
  shareSuccess,
  stopPlayVideo
}

class VideoItemActionCreator {
  
  static Action onDownloadVideo() {
    return Action(VideoItemAction.onDownloadVideo);
  }
  static Action stopPlayVideo() {
    return const Action(VideoItemAction.stopPlayVideo);
  }

  static Action refresh() {
    return Action(VideoItemAction.refresh);
  }

  static Action onDownloadImg() {
    return Action(VideoItemAction.onDownloadImg);
  }

  ///点击了视频
  static Action onVideoClick(IjkBaseVideoController controller) {
    return Action(VideoItemAction.onVideoClick, payload: controller);
  }

  ///点击了视频
  static Action onVideoClick1(ChewieController controller) {
    return Action(VideoItemAction.onVideoClick, payload: controller);
  }

  ///视频回调
  static Action onVideoUpdate(IjkBaseVideoController controller) {
    return Action(VideoItemAction.onVideoUpdate, payload: controller);
  }

  static Action onUser() {
    return Action(VideoItemAction.onUser);
  }

  ///用户主动视频回调，autoPlayModel.refreshPlayer
  static Action onVideoRefresh(IjkBaseVideoController controller) {
    return Action(VideoItemAction.onVideoRefresh, payload: controller);
  }

  ///视频初始化回调
  static Action onVideoInited(IjkBaseVideoController controller) {
    return Action(VideoItemAction.onVideoInited, payload: controller);
  }

  ///视频初始化回调
  static Action onVideoDoubleClick(IjkBaseVideoController controller) {
    return Action(VideoItemAction.onVideoDoubleClick, payload: controller);
  }

  static Action onFollow(Map<String, dynamic> map) {
    return Action(VideoItemAction.onFollow, payload: map);
  }

  static Action onTapTag(Map<String, dynamic> map) {
    return Action(VideoItemAction.onTapTag, payload: map);
  }

  static Action refreshFollowStatus(String uniqueId) {
    return Action(VideoItemAction.refreshFollowStatus, payload: uniqueId);
  }

  ///点击城市
  static Action onClickCity() {
    return Action(VideoItemAction.onClickCity);
  }

  ///点赞和取消点赞
  static Action onLove() {
    return Action(VideoItemAction.onLove);
  }

  ///购买VIP
  static Action onBuyProduct() {
    return Action(VideoItemAction.onBuyProduct);
  }

  ///打开评论
  static Action onClickComment() {
    return Action(VideoItemAction.onClickComment);
  }

  ///打开分享
  static Action onShowShare() {
    return Action(VideoItemAction.onShowShare);
  }

  ///购买VIP弹框
  static Action onShowVipDialog() {
    return Action(VideoItemAction.onShowVipDialog);
  }

  ///刷新ITEM
  static Action refreshUI(String uniqueId) {
    return Action(VideoItemAction.refreshUI, payload: uniqueId);
  }

  static Action shareSuccess(int uniqueId) {
    return Action(VideoItemAction.shareSuccess, payload: uniqueId);
  }


  static Action cacheVideo() {
    return const Action(VideoItemAction.cacheVideo);
  }

}
