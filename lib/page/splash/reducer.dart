import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SplashState> buildReducer() {
  return asReducer(
    <Object, Reducer<SplashState>>{
      SplashAction.changeText: _onChangeText,
      SplashAction.showAds: _showAds,
      SplashAction.onCountDownTime: _onCountDownTime,
      SplashAction.onFuckIt: _onFuckIt,
      SplashAction.onFindList: _onFindList,
      SplashAction.onAreaList: _onAreaList,
      SplashAction.onCommunityList: _onCommunityList,
    },
  );
}

SplashState _onFindList(SplashState state, Action action) {
  final SplashState newState = state.clone()..findList = action.payload;
  return newState;
}

SplashState _onAreaList(SplashState state, Action action) {
  final SplashState newState = state.clone()..areaList = action.payload;
  return newState;
}

///改变文字
SplashState _onChangeText(SplashState state, Action action) {
  final SplashState newState = state.clone();
  return newState;
}

///展示首页广告
SplashState _showAds(SplashState state, Action action) {
  return state.clone()..adsBean = action.payload;
}

SplashState _onFuckIt(SplashState state, Action action) {
  final SplashState newState = state.clone()..list = action.payload;
  return newState;
}

///倒计时
SplashState _onCountDownTime(SplashState state, Action action) {
  final SplashState newState = state.clone();
  newState.countdownTime = action.payload;
  return newState;
}

///首页推荐标签数据
SplashState _onCommunityList(SplashState state, Action action) {
  final SplashState newState = state.clone()..community = action.payload;
  return newState;
}
