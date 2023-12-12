import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/user/video_user_center/model/refresh_model.dart';

import 'component/state.dart';

enum UserBuyPostAction {
  onLoadData,
  loadDataSuccess,
  loadDataFail,
  onUpdateUid,
  onRefreshFollowStatus,
}

class UserBuyPostActionCreator {

  static Action onUpdateUid(RefreshModel refreshModel) {
    return Action(UserBuyPostAction.onUpdateUid,payload: refreshModel);
  }

  static Action onLoadData() {
    return Action(UserBuyPostAction.onLoadData);
  }

  static Action loadDataSuccess(List<BuyItemState> list) {
    return Action(UserBuyPostAction.loadDataSuccess, payload: list);
  }

  static Action loadDataFail() {
    return Action(UserBuyPostAction.loadDataFail);
  }

  static Action onRefreshFollowStatus(Map<String,dynamic> map) {
    return Action(UserBuyPostAction.onRefreshFollowStatus,payload: map);
  }
}
