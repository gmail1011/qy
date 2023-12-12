import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/search/search_topic_model.dart';
import 'package:flutter_app/page/search/search_tag/search_tag_item/state.dart';

import 'action.dart';
import 'state.dart';

Reducer<HotListState> buildReducer() {
  return asReducer(
    <Object, Reducer<HotListState>>{
      HotListAction.action: _onAction,
      HotListAction.onInitDataSuccess: _onInitDataSuccess
    },
  );
}

HotListState _onAction(HotListState state, Action action) {
  final HotListState newState = state.clone();
  return newState;
}

HotListState _onInitDataSuccess(HotListState state, Action action) {
  final HotListState newState = state.clone();
  SearchTopicModel searchTopicModel = action.payload;
  newState.topModel = searchTopicModel;
  if (state.pageNumber == 1) {
    newState.videoList = searchTopicModel.list;
  } else {
    newState.videoList.addAll(searchTopicModel.list);
  }

  ///加上adapter
  List<SearchTagItemState> list = [];
  for (int i = 0; i < newState.videoList.length; i++) {
    list.add(SearchTagItemState(videoModel: newState.videoList[i], bean: state.bean));
  }
  newState.items = list;
  return newState;
}
