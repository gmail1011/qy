import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_app/page/user/video_user_center/model/refresh_model.dart';


enum UserDynamicPostAction {
  onLoadData,
  loadDataSuccess,
  loadDataFail,
  onUpdateUid,
  initView,
  onRefreshFollowStatus,
  refreshFollowStatus,
}

class UserDynamicPostActionCreator {
  static Action onUpdateUid(RefreshModel refreshModel) {
    return Action(UserDynamicPostAction.onUpdateUid, payload: refreshModel);
  }

  static Action onLoadData() {
    return Action(UserDynamicPostAction.onLoadData);
  }

  static Action loadDataSuccess(List<PostItemState> list) {
    return Action(UserDynamicPostAction.loadDataSuccess, payload: list);
  }

  static Action loadDataFail() {
    return Action(UserDynamicPostAction.loadDataFail);
  }

  static Action initView() {
    return Action(UserDynamicPostAction.initView);
  }

  static Action onRefreshFollowStatus(Map<String, dynamic> map) {
    return Action(UserDynamicPostAction.onRefreshFollowStatus, payload: map);
  }

  static Action refreshFollowStatus() {
    return Action(UserDynamicPostAction.refreshFollowStatus);
  }
}
