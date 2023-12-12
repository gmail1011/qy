import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/city_model.dart';

import 'action.dart';
import 'state.dart';

Reducer<CitySelectState> buildReducer() {
  return asReducer(
    <Object, Reducer<CitySelectState>>{
      CitySelectAction.getCityListSuccess: _onGetCityListSuccess,
      CitySelectAction.onSlideCityList: _onSlideList,
      CitySelectAction.getHistory: _onGetHistoryListSuccess,
      CitySelectAction.updateUI: _updateUI
    },
  );
}

///城市选择成功
CitySelectState _onGetCityListSuccess(CitySelectState state, Action action) {
  final CitySelectState newState = state.clone();
  newState.cityList = action.payload;
  newState.cityList.insert(0, CityInfo());
  // newState.hotCityList
  //     .add(CityInfo(name: "北京市", tagIndex: "★", province: "北京市"));
  // newState.hotCityList
  //     .add(CityInfo(name: "广州市", tagIndex: "★", province: "广东省"));
  // newState.hotCityList
  //     .add(CityInfo(name: "上海市", tagIndex: "★", province: "上海市"));
  // newState.hotCityList
  //     .add(CityInfo(name: "成都市", tagIndex: "★", province: "四川省"));
  // newState.hotCityList
  //     .add(CityInfo(name: "深圳市", tagIndex: "★", province: "广东省"));
  // newState.hotCityList
  //     .add(CityInfo(name: "天津市", tagIndex: "★", province: "天津市"));
  // newState.hotCityList
  //     .add(CityInfo(name: "杭州市", tagIndex: "★", province: "浙江省"));
  // newState.hotCityList
  //     .add(CityInfo(name: "武汉市", tagIndex: "★", province: "湖北省"));
  // newState.hotCityList
  //     .add(CityInfo(name: "南京", tagIndex: "★", province: "江苏省"));
  // newState.suspensionTag = newState.hotCityList[0].getSuspensionTag();
  return newState;
}

///
CitySelectState _onSlideList(CitySelectState state, Action action) {
  final CitySelectState newState = state.clone();
  newState.suspensionTag = action.payload;
  return newState;
}

///获取历史记录成功
CitySelectState _onGetHistoryListSuccess(CitySelectState state, Action action) {
  final CitySelectState newState = state.clone();
  newState.recentCityList = action.payload;
  return newState;
}

///更新UI
CitySelectState _updateUI(CitySelectState state, Action action) {
  final CitySelectState newState = state.clone();
  return newState;
}
