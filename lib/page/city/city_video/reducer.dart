import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Reducer<CityVideoState> buildReducer() {
  return asReducer(
    <Object, Reducer<CityVideoState>>{
      CityVideoAction.onCityDetail: _onCityDetail,
      CityVideoAction.onCityStatusChangeSuccess: _onCityStatusChangeSuccess,
      CityVideoAction.onGetCityVideoList: _onGetCityVideoList,
      CityVideoAction.onGetCityLongVideoList: _onGetCityLongVideoList,
      CityVideoAction.onGetCityCoverList: _onGetCityCoverList,
      CityVideoAction.onCollectSuccess: _onCollectSuccess,
      CityVideoAction.onError: _onError,
      CityVideoAction.onMovieLoadMore: _onMovieLoadMore,
      CityVideoAction.onCoverLoadMore: _onCoverLoadMore,
      CityVideoAction.onLongMovieLoadMore: _onLongMovieLoadMore,
    },
  );
}

CityVideoState _onCityDetail(CityVideoState state, Action action) {
  final CityVideoState newState = state.clone();
  newState.cityDetailModel = action.payload;
  return newState;
}

CityVideoState _onError(CityVideoState state, Action action) {
  final CityVideoState newState = state.clone();
  newState.serverIsNormal = false;
  return newState;
}

CityVideoState _onCityStatusChangeSuccess(CityVideoState state, Action action) {
  final CityVideoState newState = state.clone();

  newState.cityDetailModel.isHaveCollect = action.payload;
  return newState;
}

CityVideoState _onGetCityVideoList(CityVideoState state, Action action) {
  final CityVideoState newState = state.clone();

  newState.nearbyBean = action.payload;
  return newState;
}

CityVideoState _onGetCityLongVideoList(CityVideoState state, Action action) {
  final CityVideoState newState = state.clone();
  newState.nearbyLongBean = action.payload;
  return newState;
}

CityVideoState _onGetCityCoverList(CityVideoState state, Action action) {
  final CityVideoState newState = state.clone();

  newState.nearbyCoverBean = action.payload;
  return newState;
}

CityVideoState _onCollectSuccess(CityVideoState state, Action action) {
  final CityVideoState newState = state.clone();
  newState.items[action.payload].videoModel.vidStatus.hasCollected =
      !newState.items[action.payload].videoModel.vidStatus.hasCollected;
  return newState;
}


CityVideoState _onMovieLoadMore(CityVideoState state, Action action) {
  final CityVideoState newState = state.clone();
  newState.pageNumber = action.payload;
  return newState;
}

CityVideoState _onLongMovieLoadMore(CityVideoState state, Action action) {
  final CityVideoState newState = state.clone();
  newState.pageLongMovieNumber = action.payload;
  return newState;
}

CityVideoState _onCoverLoadMore(CityVideoState state, Action action) {
  final CityVideoState newState = state.clone();
  newState.pageCoverNumber = action.payload;
  return newState;
}
