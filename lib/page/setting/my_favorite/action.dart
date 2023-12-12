import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/city_detail_model.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/model/video_model.dart';

enum MyFavoriteAction {
  backAction,
  onRequestVideoData,
  onRequestLocationData,
  onRequestTagData,
  loadMoreVideoData,
  loadMoreLocationData,
  loadMoreTagData,
  onLoadMoreVideoData,
  onLoadMoreLocationData,
  onLoadMoreTagData,
  onVideoError,
  onCityError,
  onTagError,
  changeEditState,
  clearEditState,
  updateUI
}

class MyFavoriteActionCreator {
  static Action onBack() {
    return const Action(MyFavoriteAction.backAction);
  }

  static Action onRequestVideoData(List<VideoModel> model) {
    return Action(MyFavoriteAction.onRequestVideoData, payload: model);
  }

  static Action onRequestLocationData(List<CityDetailModel> model) {
    return Action(MyFavoriteAction.onRequestLocationData, payload: model);
  }

  static Action onRequestTagData(List<TagDetailModel> model) {
    return Action(MyFavoriteAction.onRequestTagData, payload: model);
  }

  static Action loadMoreVideoData() {
    return Action(MyFavoriteAction.loadMoreVideoData);
  }

  static Action loadMoreLocationData() {
    return Action(MyFavoriteAction.loadMoreLocationData);
  }

  static Action loadMoreTagData() {
    return Action(MyFavoriteAction.loadMoreTagData);
  }

  static Action onLoadMoreVideoData(List<VideoModel> list) {
    return Action(MyFavoriteAction.onLoadMoreVideoData, payload: list);
  }

  static Action onLoadMoreLocationData(List<CityDetailModel> list) {
    return Action(MyFavoriteAction.onLoadMoreLocationData, payload: list);
  }

  static Action onLoadMoreTagData(List<TagDetailModel> list) {
    return Action(MyFavoriteAction.onLoadMoreTagData, payload: list);
  }

  static Action onVideoError() {
    return Action(MyFavoriteAction.onVideoError);
  }

  static Action onCityError() {
    return Action(MyFavoriteAction.onCityError);
  }

  static Action onTagError() {
    return Action(MyFavoriteAction.onTagError);
  }

  static Action changeEditState(int index) {
    return Action(MyFavoriteAction.changeEditState, payload: index);
  }

  static Action clearEditState(int index) {
    return Action(MyFavoriteAction.clearEditState, payload: index);
  }

  static Action updateUI() {
    return const Action(MyFavoriteAction.updateUI);
  }
}
