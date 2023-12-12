import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';

import 'guess_like_entity.dart';
import 'hot_recommend_entity.dart';

enum SearchAction {
  refresh,
  action,
  hotRecommend,
  getHotRecommend,
  guessLike,
  onLoadMore,
  getSubList,
  clearHistory,
  reFreshGuessYouLike,
  getHotTag,
  updateGuessLikeList
}

class SearchActionCreator {
  static Action reFresh() {
    return Action(
      SearchAction.refresh,
    );
  }

  static Action reFreshGuessYouLike(GuessLikeData guessLikeData) {
    return Action(SearchAction.reFreshGuessYouLike, payload: guessLikeData);
  }

  static Action clearHistory() {
    return Action(
      SearchAction.clearHistory,
    );
  }

  static Action onAction(int count) {
    return Action(SearchAction.action, payload: count);
  }

  static Action getHotRecommend() {
    return Action(SearchAction.getHotRecommend);
  }

  static Action onHotRecommend(HotRecommendData recommendData) {
    return Action(SearchAction.hotRecommend, payload: recommendData);
  }

  static Action guessLike(GuessLikeData recommendData) {
    return Action(SearchAction.guessLike, payload: recommendData);
  }

  static Action onLoadMore(int pageNum) {
    return Action(SearchAction.onLoadMore, payload: pageNum);
  }

  static Action getSubList(List<List<HotRecommendDataList>> xList) {
    return Action(SearchAction.getSubList, payload: xList);
  }

  static Action getTags(List<List<TagDetailModel>> xList) {
    return Action(SearchAction.getHotTag, payload: xList);
  }

  static Action updateGuessLikeList(int startIndex) {
    return Action(SearchAction.updateGuessLikeList, payload: startIndex);
  }
}
