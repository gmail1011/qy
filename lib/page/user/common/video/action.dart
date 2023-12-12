import 'package:fish_redux/fish_redux.dart';

enum LongVideoAction { updateUI, refresh, loadMore, deleteVideo ,collectBatch}

class LongVideoActionCreator {
  static Action refreshVideo() => const Action(LongVideoAction.refresh);

  static Action loadMoreVideo() => const Action(LongVideoAction.loadMore);

  static Action updateUI() => const Action(LongVideoAction.updateUI);

  static Action collectBatch(List<String> objID)=> Action(LongVideoAction.collectBatch, payload: objID);

  static Action deleteVideo(String videoId) =>
      Action(LongVideoAction.deleteVideo, payload: videoId);
}
