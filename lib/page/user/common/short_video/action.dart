import 'package:fish_redux/fish_redux.dart';

enum ShortVideoAction { updateUI, refresh, loadMore, deleteVideo ,collectBatch}

class ShortVideoActionCreator {
  static Action refreshVideo() => const Action(ShortVideoAction.refresh);

  static Action loadMoreVideo() => const Action(ShortVideoAction.loadMore);

  static Action updateUI() => const Action(ShortVideoAction.updateUI);

  static Action collectBatch(List<String> objID)=> Action(ShortVideoAction.collectBatch, payload: objID);

  static Action deleteVideo(String videoId) =>
      Action(ShortVideoAction.deleteVideo, payload: videoId);
}
