import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/search/search_topic_model.dart';
import 'package:flutter_app/page/search/search_tag/search_tag_item/state.dart';

enum HotListAction { action, onInitDataSuccess, onLoadMore, onclickVideo }

class HotListActionCreator {
  static Action onAction() {
    return const Action(HotListAction.action);
  }

  static Action onInitDataSuccess(SearchTopicModel topModel) {
    return Action(HotListAction.onInitDataSuccess, payload: topModel);
  }

  static Action onLoadMore() {
    return Action(HotListAction.onLoadMore);
  }

  static Action onclickVideo(SearchTagItemState state) {
    return Action(HotListAction.onclickVideo, payload: state);
  }
}
