import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/user/common/short_video/action.dart';

enum TopicAction {
  updateUI,
  refresh,
  loadMore,
  topicError,
  delCollectTag,
  clickCollectTag,
  collectBatch,
}

class TopicActionCreator {
  static Action updateUI() => const Action(TopicAction.updateUI);

  static Action topicError() => const Action(TopicAction.topicError);

  static Action refresh() => const Action(TopicAction.refresh);

  static Action loadMore() => const Action(TopicAction.loadMore);

  static Action delCollectTag(String tagID) =>
      Action(TopicAction.delCollectTag, payload: tagID);

  static Action collectBatch(List<String> objID)=> Action(TopicAction.collectBatch, payload: objID);

  static Action clickCollectTag(String tagID, bool collected) =>
      Action(TopicAction.clickCollectTag, payload: {
        "tagID": tagID,
        "collected": collected,
      });
}
