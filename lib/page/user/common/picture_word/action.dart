import 'package:fish_redux/fish_redux.dart';

enum PictureWordAction {
  updateUI,
  doLike,
  refreshVideo,
  picListLoadMore,
  forward,
  operateCollect,
  delCollect,
  collectBatch,
  followUser
}

class PictureWordActionCreator {
  static Action updateUI() => const Action(PictureWordAction.updateUI);

  static Action followUser(int followUID) =>
      Action(PictureWordAction.followUser, payload: followUID);

  static Action doLike(String videoId, bool isLiked) =>
      Action(PictureWordAction.doLike,
          payload: {"videoId": videoId, "isLiked": isLiked});

  static Action refreshVideo() => const Action(PictureWordAction.refreshVideo);

  static Action picListLoadMore() =>
      const Action(PictureWordAction.picListLoadMore);

  static Action forward(String videoId) =>
      Action(PictureWordAction.forward, payload: videoId);

  static Action operateCollect(String videoId, bool hasCollected) =>
      Action(PictureWordAction.operateCollect, payload: {
        "videoId": videoId,
        "hasCollected": hasCollected,
      });

  static Action deleteCollect(String videoId) =>
      Action(PictureWordAction.delCollect, payload: videoId);

  static Action collectBatch(List<String> objID)=> Action(PictureWordAction.collectBatch, payload: objID);

}
