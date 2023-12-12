import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/tag/tag_bean.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/page/tag/tag_home/compont/cell/state.dart';

///使用枚举定义相应的type
enum TagAction {
  onCollection, //点击收藏
  add, //收藏
  requestTagDetail,
  changeCollectStatusSuccess,
  requestVideoListSuccess,
  requestWordListSuccess,
  requestMovieListSuccess,
  loadMoreData,
  onclickVideo,
  onVideoRecode,
  onError,
  onGetTagDetail,
  onTitleIsShow,
  refreshUI,
  onVideoLoadMore,
  onCoverLoadMore,
  onMovieLoadMore,
}

///定义一系列action
class TagActionCreator {

  /// 点击收藏
  static Action onCollection() {
    return const Action(TagAction.onCollection);
  }
/// 点击收藏
  static Action onRefreshUI() {
    return const Action(TagAction.refreshUI);
  }
  /// 收藏
  static Action add(bool hasCollect) {
    return Action(TagAction.add, payload: hasCollect);
  }

  ///收藏成功
  static Action changeCollectStatusSuccess(bool hasCollect) {
    return Action(TagAction.changeCollectStatusSuccess, payload: hasCollect);
  }

  /// 请求标签详情
  static Action requestTagDetail(TagDetailModel tagDetailModel) {
    return Action(TagAction.requestTagDetail, payload: tagDetailModel);
  }

  static Action requestVideoListSuccess(TagBean tagsBean) {
    return Action(TagAction.requestVideoListSuccess, payload: tagsBean);
  }
  static Action requestWordListSuccess(TagBean tagsBean) {
    return Action(TagAction.requestWordListSuccess, payload: tagsBean);
  }
  static Action requestMovieListSuccess(TagBean tagsBean) {
    return Action(TagAction.requestMovieListSuccess, payload: tagsBean);
  }

  static Action loadMoreData(int pageNumber) {
    return Action(TagAction.loadMoreData, payload: pageNumber);
  }

  static Action onclickVideo(TagItemState tagItemState) {
    return Action(TagAction.onclickVideo, payload: tagItemState);
  }

  static Action onVideoRecode() {
    return const Action(TagAction.onVideoRecode);
  }

  static Action onError(String msg) {
    return Action(TagAction.onError,payload: msg);
  }

  static Action onGetTagDetail() {
    return const Action(TagAction.onGetTagDetail);
  }

  static Action onTitleIsShow(bool isShow) {
    return Action(TagAction.onTitleIsShow,payload: isShow);
  }

  static Action onVideoLoadMore(int isShow) {
    return Action(TagAction.onVideoLoadMore,payload: isShow);
  }

  static Action onCoverLoadMore(int isShow) {
    return Action(TagAction.onCoverLoadMore,payload: isShow);
  }

  static Action onMovieLoadMore(int isShow) {
    return Action(TagAction.onMovieLoadMore,payload: isShow);
  }
}
