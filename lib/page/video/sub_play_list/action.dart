import 'package:fish_redux/fish_redux.dart';

enum SubPlayListAction {
  loadDataAction,
  onLoadSuccessAction,
  refreshFollowStatus,
  onRefreshFollowStatus,
  beginAutoPlay,
  goVideoPlayList,
}

class SubPlayListActionCreator {
  ///获取数据
  static Action loadData() {
    return Action(SubPlayListAction.loadDataAction);
  }

  ///本页面刷新
  static Action refreshFollowStatus() {
    return Action(SubPlayListAction.refreshFollowStatus);
  }

  static Action onRefreshFollowStatus(Map<String, dynamic> map) {
    return Action(SubPlayListAction.onRefreshFollowStatus, payload: map);
  }

  ///获取数据成功
  static Action onLoadSuccess() {
    return Action(SubPlayListAction.onLoadSuccessAction);
  }

  /// 更新当前的播放索引,主要是释放UI的，是否允许播放器显示，这个控制，和播放器本身播放控制无关
  static Action setAutoPlayIndex(int index) {
    return Action(SubPlayListAction.beginAutoPlay, payload: index);
  }

  static Action goVideoPlayList() {
    return Action(SubPlayListAction.goVideoPlayList);
  }
  
}
