import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/city_detail_model.dart';
import 'package:flutter_app/model/nearby_bean.dart';

enum CityVideoAction {
  onCityDetail,
  onCityStatusChangeSuccess,
  onGetCityVideoList,
  onGetCityLongVideoList,
  onInitData,
  onCollectSuccess,
  onError,
  onGetData,

  onMovieLoadMore,
  onCoverLoadMore,
  onLongMovieLoadMore,
  onGetCityCoverList,
}

class CityVideoActionCreator {

  static Action onCityDetail(CityDetailModel cityDetailModel) {
    return Action(CityVideoAction.onCityDetail, payload: cityDetailModel);
  }

  static Action onCityStatusChangeSuccess(bool isCollect) {
    return Action(CityVideoAction.onCityStatusChangeSuccess, payload: isCollect);
  }

  static Action onGetCityVideoList(NearbyBean nearbyBean) {
    return Action(CityVideoAction.onGetCityVideoList, payload: nearbyBean);
  }
  static Action onGetCityLongVideoList(NearbyBean nearbyBean) {
    return Action(CityVideoAction.onGetCityLongVideoList, payload: nearbyBean);
  }

  static Action onGetCityCoverList(NearbyBean nearbyBean) {
    return Action(CityVideoAction.onGetCityCoverList, payload: nearbyBean);
  }

  static Action onInitData() {
    return Action(CityVideoAction.onInitData);
  }

  static Action onCollectSuccess(int index) {
    return  Action(CityVideoAction.onCollectSuccess,payload: index);
  }

  static Action onError(String msg) {
    return Action(CityVideoAction.onError,payload: msg);
  }

  static Action onGetData() {
    return Action(CityVideoAction.onGetData);
  }

  static Action onMovieLoadMore(int nearbyBean) {
    return Action(CityVideoAction.onMovieLoadMore, payload: nearbyBean);
  }

  static Action onCoverLoadMore(int nearbyBean) {
    return Action(CityVideoAction.onCoverLoadMore, payload: nearbyBean);
  }
}
