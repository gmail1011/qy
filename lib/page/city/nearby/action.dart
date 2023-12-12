import 'package:fish_redux/fish_redux.dart';

enum NearbyAction {
  onError,
  onRefresh,
  RequestDataSuccess,
  selectCity,
  selectCitySuccess,
  loadMore,
  onItemClick,
  setIsShowTopBtn,
  onRefreshFollowStatus,
}

class NearbyActionCreator {
  static Action setIsShowTopBtn(bool isShow) {
    return Action(NearbyAction.setIsShowTopBtn, payload: isShow);
  }

  static Action requestDataSuccess() {
    return Action(NearbyAction.RequestDataSuccess);
  }

  static Action selectCity() {
    return Action(NearbyAction.selectCity);
  }

  static Action selectCitySuccess(String city) {
    return Action(NearbyAction.selectCitySuccess, payload: city);
  }

  static Action loadMore() {
    return Action(
      NearbyAction.loadMore,
    );
  }

  static Action onItemClick(int position) {
    return Action(NearbyAction.onItemClick, payload: position);
  }

  static Action onError(String msg) {
    return Action(NearbyAction.onError, payload: msg);
  }

  static Action onRefresh() {
    return Action(NearbyAction.onRefresh);
  }

  ///外部  更新关注数据
  static Action onRefreshFollowStatus(Map<String, dynamic> map) {
    return Action(NearbyAction.onRefreshFollowStatus, payload: map);
  }
}
