import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/res/watch_list_model.dart';
import 'package:flutter_base/utils/array_util.dart';

import 'action.dart';
import 'state.dart';

Reducer<MineFollowState> buildReducer() {
  return asReducer(
    <Object, Reducer<MineFollowState>>{
      MineFollowAction.onRefreshOkay: _onRefreshOkay,
      MineFollowAction.onLoadMoreOkay: _onLoadMoreOkay,
      MineFollowAction.onFollowOkay: _onFollowOkay,
    },
  );
}

MineFollowState _onRefreshOkay(MineFollowState state, Action action) {
  List<WatchModel> list = action.payload;
  if (ArrayUtil.isEmpty(list)) return state;
  return state.clone()..list = list;
}

MineFollowState _onLoadMoreOkay(MineFollowState state, Action action) {
  List<WatchModel> list = action.payload;
  if (ArrayUtil.isEmpty(list)) return state;
  var newList = List<WatchModel>.from(state.list);
  newList.addAll(list);
  return state.clone()..list = newList;
}

// 关注或者取消关注
MineFollowState _onFollowOkay(MineFollowState state, Action action) {
  var map = action.payload as Map;
  int index = map["index"];
  bool follow = map["follow"];
  var newList = List<WatchModel>.from(state.list);
  // newList.removeAt(index);
  newList[index].hasFollow = follow;
  return state.clone()..list = newList;
}
