import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/user/video_user_center/model/refresh_model.dart';

import 'component/state.dart';

enum MineLikePostAction {
  onLoadData,
  loadDataSuccess,
  loadDataFail,
  onUpdateUid,
  initView,
  onRefreshFollowStatus,
  setLoadFinish,
}

class MineLikePostActionCreator {

  static Action onUpdateUid(RefreshModel refreshModel) {
    return Action(MineLikePostAction.onUpdateUid,payload: refreshModel);
  }

  static Action onLoadData() {
    return Action(MineLikePostAction.onLoadData);
  }

  static Action loadDataSuccess(List<MineLikeItemState> list) {
    return Action(MineLikePostAction.loadDataSuccess, payload: list);
  }

  static Action loadDataSuccess1(MineVideo works) {
    return Action(MineLikePostAction.loadDataSuccess, payload: works);
  }

  static Action loadDataFail() {
    return Action(MineLikePostAction.loadDataFail);
  }

  static Action initView() {
    return Action(MineLikePostAction.initView);
  }

  static Action onRefreshFollowStatus(Map<String,dynamic> map) {
    return Action(MineLikePostAction.onRefreshFollowStatus,payload: map);
  }

  static Action setLoadFinish(bool loadcomplete) {
    return Action(MineLikePostAction.setLoadFinish,payload: loadcomplete,);
  }
}
