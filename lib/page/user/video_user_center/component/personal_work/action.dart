import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/user/video_user_center/model/refresh_model.dart';

import 'component/state.dart';

enum UserWorkPostAction {
  onLoadData,
  loadDataSuccess,
  loadDataFail,
  onUpdateUid,
  initView,
  onRefreshFollowStatus,
}

class UserWorkPostActionCreator {

  static Action onUpdateUid(RefreshModel refreshModel) {
    return Action(UserWorkPostAction.onUpdateUid,payload: refreshModel);
  }

  static Action onLoadData() {
    return Action(UserWorkPostAction.onLoadData);
  }

  static Action loadDataSuccess(List<WorkItemState> list) {
    return Action(UserWorkPostAction.loadDataSuccess, payload: list);
  }

  static Action loadDataFail() {
    return Action(UserWorkPostAction.loadDataFail);
  }

  static Action initView () {
    return Action(UserWorkPostAction.initView,);
  }

  static Action onRefreshFollowStatus(Map<String,dynamic> map) {
    return Action(UserWorkPostAction.onRefreshFollowStatus,payload: map);
  }
}
