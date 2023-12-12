import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Reducer<SubPlayListState> buildReducer() {
  return asReducer(
    <Object, Reducer<SubPlayListState>>{
      SubPlayListAction.onLoadSuccessAction: _loadSuccess,
      SubPlayListAction.refreshFollowStatus: _refreshFollowStatus,
      SubPlayListAction.beginAutoPlay: _autoPlayIndex,
    },
  );
}

///刷新关注状态
SubPlayListState _refreshFollowStatus(SubPlayListState state, Action action) {
  return state.clone();
}

///加载更多数据成功
SubPlayListState _loadSuccess(SubPlayListState state, Action action) {
  final SubPlayListState newState = state.clone();
  return newState;
}

SubPlayListState _autoPlayIndex(SubPlayListState state, Action action) {
  var newState = state.clone();
  // var videoList = List<VideoItemState>.from(state.videoList);
  final videoList = state.videoList;
  var newPlayIndex = (action.payload as int) ?? -1;
  if (newPlayIndex >= 0) {
    var oldPlayIndex =
        videoList.indexWhere((it) => it.enablePlay.value == true);
    if (oldPlayIndex < 0) {
      var newData = videoList[newPlayIndex];
      newData.enablePlay.forceSetValue(true);
      newState = newState.updateItemData(newPlayIndex, newData, false);
    } else if (oldPlayIndex != newPlayIndex) {
      // newList[oldPlayIndex].enablePlay.value = false;
      var oldData = videoList[oldPlayIndex];
      oldData.enablePlay.value = false;
      newState = newState.updateItemData(oldPlayIndex, oldData, false);

      // newList[newPlayIndex].enablePlay.value = true;
      var newData = videoList[newPlayIndex];
      newData.enablePlay.forceSetValue(true);
      newState = newState.updateItemData(newPlayIndex, newData, false);
    } else {
      // newList[newPlayIndex].enablePlay.value = true;

      var newData = videoList[newPlayIndex];
      newData.enablePlay.forceSetValue(true);
      newState = newState.updateItemData(newPlayIndex, newData, false);
    }
  } else {
    for (var item in videoList) {
      item.enablePlay.value = false;
    }
  }
  // for (var item in newList) {
  //   item.enablePlay.value = false;
  // }
  // newState.videoList = videoList;
  // var playIndex = (action.payload as int) ?? -1;
  // if (playIndex >= 0 && playIndex < (newState.videoList?.length ?? 0)) {
  //   var data = newState.videoList[playIndex];
  //   data.enablePlay.value = true;
  //   newState = newState.updateItemData(playIndex, data, false);
  // }
  if (newPlayIndex >= 0) {
    newState.curVideoIndex = newPlayIndex;
    // l.i("subPlayList","_autoPlayIndex()...setPlayIndex:$playIndex");
  }
  return newState;
}
