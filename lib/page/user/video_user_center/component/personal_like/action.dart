import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/user/video_user_center/model/refresh_model.dart';

import 'component/state.dart';

enum UserLikePostAction {
  onLoadData,
  loadDataSuccess,
  loadDataFail,
  onUpdateUid,
  initView,
  onRefreshFollowStatus,
}

class UserLikePostActionCreator {

  static Action onUpdateUid(RefreshModel refreshModel) {
    return Action(UserLikePostAction.onUpdateUid,payload: refreshModel);
  }

  static Action onLoadData() {
    return Action(UserLikePostAction.onLoadData);
  }

  static Action loadDataSuccess(List<LikeItemState> list) {
    return Action(UserLikePostAction.loadDataSuccess, payload: list);
  }

  static Action loadDataFail() {
    return Action(UserLikePostAction.loadDataFail);
  }

  static Action initView() {
    return Action(UserLikePostAction.initView);
  }

  static Action onRefreshFollowStatus(Map<String,dynamic> map) {
    return Action(UserLikePostAction.onRefreshFollowStatus,payload: map);
  }
}
