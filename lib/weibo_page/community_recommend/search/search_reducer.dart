import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/utils/log.dart';

import 'search_action.dart';
import 'search_state.dart';

Reducer<SearchState> buildReducer() {
  return asReducer(
    <Object, Reducer<SearchState>>{
      SearchAction.action: _onAction,
      SearchAction.hotRecommend: _onHotRecommend,
      SearchAction.guessLike: _guesslike,
      SearchAction.getSubList: _getSubList,
      SearchAction.refresh: reFresh,
      SearchAction.reFreshGuessYouLike: reFreshGuessYouLike,
      SearchAction.getHotTag: getHotTags,
      SearchAction.updateGuessLikeList: _updateGuessLikeList,
    },
  );
}

SearchState reFresh(SearchState state, Action action) {
  final SearchState newState = state.clone();
  return newState;
}

SearchState reFreshGuessYouLike(SearchState state, Action action) {
  final SearchState newState = state.clone();
  newState.guessLikeData = action.payload;
  return newState;
}

SearchState _onAction(SearchState state, Action action) {
  final SearchState newState = state.clone();
  newState.changeCount = action.payload;
  return newState;
}

SearchState _onHotRecommend(SearchState state, Action action) {
  final SearchState newState = state.clone();
  newState.hotRecommendData = action.payload;
  return newState;
}

SearchState _guesslike(SearchState state, Action action) {
  final SearchState newState = state.clone();
  newState.guessLikeData = action.payload;
  return newState;
}

SearchState _getSubList(SearchState state, Action action) {
  final SearchState newState = state.clone();
  newState.xList = action.payload;
  return newState;
}

SearchState getHotTags(SearchState state, Action action) {
  final SearchState newState = state.clone();
  newState.tagList = action.payload;
  return newState;
}

SearchState _updateGuessLikeList(SearchState state, Action action) {
  final SearchState newState = state.clone();
  try {
    int startIndex = action.payload as int;
    var tempGuessLikeDataList = state.guessLikeData?.xList;
    l.d("tempGuessLikeDataList.length", "${tempGuessLikeDataList.length}");

    if ((tempGuessLikeDataList ?? []).isNotEmpty) {
      int endIndex = startIndex + 3;
      if (endIndex > tempGuessLikeDataList.length) {
        endIndex = tempGuessLikeDataList.length;
        newState.changeCount = 0;
      } else {
        newState.changeCount = endIndex;
      }

      l.d("startIndex", "$startIndex");
      l.d("endIndex", "$endIndex");
      ///特殊处理
      if(startIndex == endIndex && newState.changeCount == 0) {
        startIndex = 0;
        endIndex = startIndex + 3;
        if (endIndex > tempGuessLikeDataList.length) {
          endIndex = tempGuessLikeDataList.length;
        }
      }
      var tempDataList = tempGuessLikeDataList.sublist(startIndex, endIndex);
      newState.guessLikeShowList = tempDataList;
    }
  } catch (e) {
    l.d("_updateGuessLikeList", "$e");
    newState.guessLikeShowList = [];
    newState.changeCount = 0;
  }
  return newState;
}
