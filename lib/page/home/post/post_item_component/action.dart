import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

enum PostItemAction {
  onFollow,
  followSuccess,
  onRefreshFollowStatus,
  onCollect,
  changeCollectSuccess,
  fullTextTap,
  onPicTap,
  onTag,
  onLike,
  onCommend,
  onShare,
  onFavorite,

  onBuyVideoSuccess,
  onBuyVideo,
  onClickItem,
  tellFatherJumpPage,
  commentSuccess,
  refreshUserCenterFollowStatus,
}

class PostItemActionCreator {
  static Action onFollow(String uniqueId) {
    return Action(PostItemAction.onFollow, payload: uniqueId);
  }

  static Action refreshUserCenterFollowStatus(bool isShowUnFollow) {
    return Action(PostItemAction.refreshUserCenterFollowStatus,
        payload: isShowUnFollow);
  }

  static Action followSuccess(String uniqueId) {
    return Action(PostItemAction.followSuccess, payload: uniqueId);
  }

  static Action onRefreshFollowStatus(Map<String, dynamic> map) {
    return Action(PostItemAction.onRefreshFollowStatus, payload: map);
  }

  static Action onFavorite(PostItemState item) {
    return Action(PostItemAction.onFavorite, payload: item);
  }

  static Action onBuyVideoSuccess(String uniqueId) {
    return Action(PostItemAction.onBuyVideoSuccess, payload: uniqueId);
  }

  static Action onBuyVideo() {
    return Action(PostItemAction.onBuyVideo);
  }

  static Action onItemClick(String uniqueId) {
    return Action(PostItemAction.onClickItem, payload: uniqueId);
  }

  static Action tellFatherJumpPage(PostItemState item) {
    return Action(PostItemAction.tellFatherJumpPage, payload: item);
  }

  static Action onPicTap(int index, PostItemState item) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["index"] = index;
    map["state"] = item;
    return Action(PostItemAction.onPicTap, payload: map);
  }

  static Action fullTextTap(PostItemState item) {
    return Action(PostItemAction.fullTextTap, payload: item);
  }

  static Action onTagClick(int index, PostItemState item) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["index"] = index;
    map["state"] = item;
    return Action(PostItemAction.onTag, payload: map);
  }

  static Action onLike(Map<String, dynamic> map) {
    return Action(PostItemAction.onLike, payload: map);
  }

  static Action onCommend(String uniqueId) {
    return Action(PostItemAction.onCommend, payload: uniqueId);
  }

  static Action onShare() {
    return Action(PostItemAction.onShare);
  }

  static Action onCollect(PostItemState item) {
    return Action(PostItemAction.onCollect, payload: item);
  }

  static Action changeCollectSuccess(PostItemState item) {
    return Action(PostItemAction.changeCollectSuccess, payload: item);
  }

  static Action commentSuccess(String uniqueId) {
    return Action(PostItemAction.commentSuccess, payload: uniqueId);
  }
}
