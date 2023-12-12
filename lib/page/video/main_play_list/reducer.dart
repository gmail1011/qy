import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/video_item_commponent/state.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Reducer<MainPlayerListState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainPlayerListState>>{
      MainPlayerListAction.refreshListOkay: _refreshListOkay,
      MainPlayerListAction.showAdsView: _showAdsView,
      MainPlayerListAction.configAdsStatus: _configAdsStatus,
      MainPlayerListAction.refreshFollowStatus: _refreshFollowStatus,
      MainPlayerListAction.beginAutoPlay: _autoPlayIndex,
    },
  );
}

///刷新关注状态
MainPlayerListState _refreshFollowStatus(
    MainPlayerListState state, Action action) {
  MainPlayerListState newState = state.clone();
  return newState;
}

MainPlayerListState _autoPlayIndex(MainPlayerListState state, Action action) {
  var newState = state.clone();
  final videoList = state.videoList;

  if ((videoList ?? []).isNotEmpty) {
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
    if (newPlayIndex >= 0) {
      newState.curIndex = newPlayIndex;
      // l.i("subPlayList","_autoPlayIndex()...setPlayIndex:$playIndex");
    }
  }
  return newState;
}

///刷新数据成功(覆盖)
MainPlayerListState _refreshListOkay(MainPlayerListState state, Action action) {
  List<VideoModel> videoList = action.payload;
  l.i("videolist",
      "_refreshListOkay()... list被刷新了 type:${state.type} listSize:${videoList?.length ?? 0}");
  if (ArrayUtil.isEmpty(videoList)) return state.clone();

  final MainPlayerListState newState = state.clone();
  List<VideoItemState> itemStateList = [];
  if (videoList != null && videoList.isNotEmpty) {
    for (int iLoop = 0; iLoop < videoList.length; iLoop++) {
      VideoItemState itemState = VideoItemState(videoModel: videoList[iLoop]);
      // itemState.videoModel = videoList[iLoop];
      // 测试
      // if (itemState.vm.isVideo() && (Random().nextInt(5) % 3 == 0)) {
      //   itemState.vm.newsType = NEWSTYPE_AD_VIDEO;
      // }

      itemState.index = iLoop;
      itemState.type = state.type;
      itemState.enablePlay.value = state.curIndex == iLoop;
      itemState.uniqueId = "_uniqueId_in_type_${state.type}_at_index_$iLoop";
      itemStateList.add(itemState);
    }
    newState.videoList = itemStateList;
  }
  return newState;
}

///是否显示小广告
MainPlayerListState _showAdsView(MainPlayerListState state, Action action) {
  final MainPlayerListState newState = state.clone();
  newState.adsInfoBean = action.payload;
  newState.isShowBigAds = true;
  return newState;
}

///小广告展示小图还是大图
MainPlayerListState _configAdsStatus(MainPlayerListState state, Action action) {
  final MainPlayerListState newState = state.clone();
  newState.isShowBigAds = action.payload;
  return newState;
}
