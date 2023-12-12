import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MyFavoriteState> buildReducer() {
  return asReducer(
    <Object, Reducer<MyFavoriteState>>{
      MyFavoriteAction.onRequestVideoData: _onRequestVideoData,
      MyFavoriteAction.onRequestLocationData: _onRequestLocationData,
      MyFavoriteAction.onRequestTagData: _onRequestTagData,
      MyFavoriteAction.onLoadMoreVideoData: _onLoadMoreVideoData,
      MyFavoriteAction.onLoadMoreLocationData: _onLoadMoreLocationData,
      MyFavoriteAction.onLoadMoreTagData: _onLoadMoreTagData,
      MyFavoriteAction.onVideoError: _onVideoError,
      MyFavoriteAction.onCityError: _onCityError,
      MyFavoriteAction.onTagError: _onTagError,
      MyFavoriteAction.updateUI: _updateUI,
    },
  );
}

MyFavoriteState _onRequestVideoData(MyFavoriteState state, Action action) {
  MyFavoriteState newState = state.clone();
  newState.videoModelList = action.payload;
  newState.videoError = true;
  return newState;
}

MyFavoriteState _onRequestLocationData(MyFavoriteState state, Action action) {
  final MyFavoriteState newState = state.clone();
  newState.cityModelList = action.payload;
  newState.cityError = true;
  return newState;
}

MyFavoriteState _onRequestTagData(MyFavoriteState state, Action action) {
  final MyFavoriteState newState = state.clone();
  newState.tagModelList = action.payload;
  newState.tagError = true;
  return newState;
}

MyFavoriteState _onLoadMoreVideoData(MyFavoriteState state, Action action) {
  final MyFavoriteState newState = state.clone();
  if (newState.videoModelList != null) {
    newState.videoModelList.addAll(action.payload);
  }
  return newState;
}

MyFavoriteState _onLoadMoreLocationData(MyFavoriteState state, Action action) {
  final MyFavoriteState newState = state.clone();
  if (newState.cityModelList != null) {
    newState.cityModelList.addAll(action.payload);
  }
  return newState;
}

MyFavoriteState _onLoadMoreTagData(MyFavoriteState state, Action action) {
  final MyFavoriteState newState = state.clone();
  if (newState.tagModelList != null) {
    newState.tagModelList.addAll(action.payload);
  }
  return newState;
}

MyFavoriteState _onVideoError(MyFavoriteState state, Action action) {
  final MyFavoriteState newState = state.clone();
  newState.videoError = false;
  newState.videoErrorMsg = action.payload;
  return newState;
}

MyFavoriteState _onCityError(MyFavoriteState state, Action action) {
  final MyFavoriteState newState = state.clone()..tagModelList = action.payload;
  newState.cityError = false;
  newState.cityErrorMsg = action.payload;
  return newState;
}

MyFavoriteState _onTagError(MyFavoriteState state, Action action) {
  final MyFavoriteState newState = state.clone()..tagModelList = action.payload;
  newState.tagError = false;
  newState.tagErrorMsg = action.payload;
  return newState;
}

MyFavoriteState _updateUI(MyFavoriteState state, Action action) {
  final MyFavoriteState newState = state.clone();
  return newState;
}
