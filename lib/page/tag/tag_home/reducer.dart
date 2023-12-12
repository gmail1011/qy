import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/tag/tag_bean.dart';
import 'package:flutter_app/page/tag/tag_home/compont/cell/state.dart';

import 'action.dart';
import 'state.dart';

//Reducer常用语操作数据行为，通过拿到Action payload中数据来对数据通过浅复制方式改变数据
Reducer<TagState> buildReducer() {
  return asReducer(
    <Object, Reducer<TagState>>{
      TagAction.add: _add,
      TagAction.requestTagDetail: _requestTagDetailSuccess,
      TagAction.changeCollectStatusSuccess: _changeCollectStatusSuccess,
      TagAction.requestVideoListSuccess: _requestVideoListSuccess,
      TagAction.requestWordListSuccess: _requestWordListSuccess,
      TagAction.requestMovieListSuccess: _requestMovieListSuccess,
      TagAction.onError: _onError,
      TagAction.onTitleIsShow: _onTitleIsShow,
      TagAction.refreshUI: _refreshUI,

      TagAction.onVideoLoadMore: onVideoLoadMore,
      TagAction.onCoverLoadMore: onWordLoadMore,
      TagAction.onMovieLoadMore: onMovieLoadMore,
    },
  );
}

///刷新UI
TagState _refreshUI(TagState state, Action action) {
  final TagState newState = state.clone();
  return newState;
}

TagState _add(TagState state, Action action) {
  final TagState newState = state.clone();
  newState.count += state.count + 1;
  return newState;
}

TagState _changeCollectStatusSuccess(TagState state, Action action) {
  final TagState newState = state.clone();
  state.tagDetailModel.hasCollected = action.payload;
  return newState;
}

TagState _onTitleIsShow(TagState state, Action action) {
  final TagState newState = state.clone();
  newState.isShowTitle = action.payload;
  return newState;
}

TagState _requestTagDetailSuccess(TagState state, Action action) {
  final TagState newState = state.clone();
  newState.serverIsNormal = true;
  newState.tagDetailModel = action.payload;
  return newState;
}

TagState _onError(TagState state, Action action) {
  final TagState newState = state.clone();
  newState.errorMsg = action.payload;
  return newState;
}

TagState _requestVideoListSuccess(TagState state, Action action) {
  final TagState newState = state.clone();
  newState.tagVideoBean = action.payload;
  return newState;
}

TagState _requestWordListSuccess(TagState state, Action action) {
  final TagState newState = state.clone();
  newState.tagWordBean = action.payload;
  return newState;
}

TagState _requestMovieListSuccess(TagState state, Action action) {
  final TagState newState = state.clone();
  newState.tagMovieBean = action.payload;
  return newState;
}


TagState onVideoLoadMore(TagState state, Action action) {
  final TagState newState = state.clone();
  newState.pageNumber = action.payload;
  return newState;
}

TagState onWordLoadMore(TagState state, Action action) {
  final TagState newState = state.clone();
  newState.pageWordNumber = action.payload;
  return newState;
}

TagState onMovieLoadMore(TagState state, Action action) {
  final TagState newState = state.clone();
  newState.pageMovieNumber = action.payload;
  return newState;
}
