import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net/api.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/base_response.dart';
import 'package:flutter_app/model/city_detail_model.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/model/video_paged_list.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'state.dart';

Effect<MyFavoriteState> buildEffect() {
  return combineEffects(<Object, Effect<MyFavoriteState>>{
    MyFavoriteAction.backAction: _backAction,
    MyFavoriteAction.loadMoreVideoData: _onLoadMoreVideoData,
    MyFavoriteAction.loadMoreLocationData: _onLoadMoreLocationData,
    MyFavoriteAction.loadMoreTagData: _onLoadMoreTagData,
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

void _initState(Action action, Context<MyFavoriteState> ctx) {
  ctx.state.tabController?.addListener(() {
    print("tabController.index:${ctx.state.tabController.index}");
    ctx.broadcast(
        MyFavoriteActionCreator.clearEditState(ctx.state.tabController.index));
  });
}

void _backAction(Action action, Context<MyFavoriteState> ctx) {
  safePopPage();
}

void _onLoadMoreVideoData(Action action, Context<MyFavoriteState> ctx) {
  onLoadMoreVideoData(ctx);
}

void _onLoadMoreLocationData(Action action, Context<MyFavoriteState> ctx) {
  onLoadMoreLocationData(ctx);
}

void _onLoadMoreTagData(Action action, Context<MyFavoriteState> ctx) {
  onLoadMoreTagData(ctx);
}

/// 获取收藏视频
requestVideoData(Context<MyFavoriteState> ctx) async {
  Map<String, dynamic> mapList = {};
  mapList['type'] = 'video';
  mapList['pageNumber'] = ctx.state.videoPageNumber;
  mapList['pageSize'] = ctx.state.pageSize;
  mapList['uid'] = GlobalStore.getMe()?.uid ?? 0;
  BaseResponse res =
      await HttpManager().get(Address.MY_FAVORITE, params: mapList);
  if (res.code == 200) {
    // PagedList list = PagedList.fromJson<VideoModel>(res.data);
    PagedList list = PagedList.fromJson(res.data);
    List<VideoModel> modelList = VideoModel.toList(list.list);
    ctx.dispatch(MyFavoriteActionCreator.onRequestVideoData(modelList));
    if (modelList == null || modelList.length == 0) {
      ctx.dispatch(MyFavoriteActionCreator.onVideoError());
    }
  } else {
    ctx.dispatch(MyFavoriteActionCreator.onVideoError());
    showToast(msg: res.msg ?? '');
  }
}

/// 获取收藏地点
requestLocationData(Context<MyFavoriteState> ctx) async {
  Map<String, dynamic> mapList = {};
  mapList['type'] = 'location';
  mapList['pageNumber'] = ctx.state.locationPageNumber;
  mapList['pageSize'] = ctx.state.pageSize;
  mapList['uid'] = GlobalStore.getMe()?.uid ?? 0;
  BaseResponse res =
      await HttpManager().get(Address.MY_FAVORITE, params: mapList);
  if (res.code == 200) {
    // PagedList list = PagedList.fromJson<CityDetailModel>(res.data);
    PagedList list = PagedList.fromJson(res.data);
    List<CityDetailModel> modelList = CityDetailModel.toList(list.list);
    ctx.dispatch(MyFavoriteActionCreator.onRequestLocationData(modelList));
    if (modelList == null || modelList.length == 0) {
      ctx.dispatch(MyFavoriteActionCreator.onCityError());
    }
  } else {
    ctx.dispatch(MyFavoriteActionCreator.onCityError());
    showToast(msg: res.msg ?? '');
  }
}

/// 获取收藏话题
requestTagData(Context<MyFavoriteState> ctx) async {
  Map<String, dynamic> mapList = {};
  mapList['type'] = 'tag';
  mapList['pageNumber'] = ctx.state.tagPageNumber;
  mapList['pageSize'] = ctx.state.pageSize;
  mapList['uid'] = GlobalStore.getMe()?.uid ?? 0;
  BaseResponse res =
      await HttpManager().get(Address.MY_FAVORITE, params: mapList);
  if (res.code == 200) {
    // PagedList list = PagedList.fromJson<TagDetailModel>(res.data);
    PagedList list = PagedList.fromJson(res.data);
    List<TagDetailModel> modelList = TagDetailModel.toList(list.list);
    ctx.dispatch(MyFavoriteActionCreator.onRequestTagData(modelList));
    if (modelList == null || modelList.length == 0) {
      ctx.dispatch(MyFavoriteActionCreator.onTagError());
    }
  } else {
    ctx.dispatch(MyFavoriteActionCreator.onTagError());
//    showToast(msg: res.msg??'');
  }
}

void onLoadMoreVideoData(Context<MyFavoriteState> ctx) async {
  Map<String, dynamic> mapList = {};
  mapList['type'] = 'video';
  mapList['pageNumber'] = ctx.state.videoPageNumber;
  mapList['pageSize'] = ctx.state.pageSize;
  mapList['uid'] = GlobalStore.getMe()?.uid ?? 0;
  BaseResponse res =
      await HttpManager().get(Address.MY_FAVORITE, params: mapList);
  if (res.code == 200) {
    // PagedList list = PagedList.fromJson<VideoModel>(res.data);
    PagedList list = PagedList.fromJson(res.data);
    if (list.list != null && list.list.isNotEmpty) {
      ctx.dispatch(MyFavoriteActionCreator.onLoadMoreVideoData(
          VideoModel.toList(list.list)));
    }
  } else {
//    showToast(msg: res.msg??'');
  }
}

void onLoadMoreLocationData(Context<MyFavoriteState> ctx) async {
  Map<String, dynamic> mapList = {};
  mapList['type'] = 'location';
  mapList['pageNumber'] = ctx.state.locationPageNumber;
  mapList['pageSize'] = ctx.state.pageSize;
  mapList['uid'] = GlobalStore.getMe()?.uid ?? 0;
  BaseResponse res =
      await HttpManager().get(Address.MY_FAVORITE, params: mapList);
  if (res.code == 200) {
    // PagedList list = PagedList.fromJson<CityDetailModel>(res.data);
    PagedList list = PagedList.fromJson(res.data);
    if (list.list != null && list.list.isNotEmpty) {
      ctx.dispatch(MyFavoriteActionCreator.onLoadMoreLocationData(
          CityDetailModel.toList(list.list)));
    }
  } else {
//    showToast(msg: res.msg??'');
  }
}

void onLoadMoreTagData(Context<MyFavoriteState> ctx) async {
  Map<String, dynamic> mapList = {};
  mapList['type'] = 'tag';
  mapList['pageNumber'] = ctx.state.tagPageNumber;
  mapList['pageSize'] = ctx.state.pageSize;
  mapList['uid'] = GlobalStore.getMe()?.uid ?? 0;
  BaseResponse res =
      await HttpManager().get(Address.MY_FAVORITE, params: mapList);
  if (res.code == 200) {
    // PagedList list = PagedList.fromJson<TagDetailModel>(res.data);
    PagedList list = PagedList.fromJson(res.data);
    if (list.list != null && list.list.isNotEmpty) {
      ctx.dispatch(MyFavoriteActionCreator.onLoadMoreTagData(
          TagDetailModel.toList(list.list)));
    }
  } else {
//    showToast(msg: res.msg??'');
  }
}

///修改编辑我的收藏状态
// void _changeEditState(Action action, Context<MyFavoriteState> ctx) {
//   int index = ctx.state.tabController?.index;
//   switch (index) {
//     case 0://我的收藏-长视频
//       bool isVideoEditState = ctx.state.isVideoEditModel;
//       ctx.state.isVideoEditModel = !isVideoEditState;
//
//
//
//       break;
//     case 1://我的收藏-短视频
//       bool isShortVideoEditState = ctx.state.isShortVideoEditModel;
//       ctx.state.isShortVideoEditModel = !isShortVideoEditState;
//
//
//       break;
//     case 2://我的收藏-图文
//       bool isPicWordEditState = ctx.state.isPicWordEditModel;
//       ctx.state.isPicWordEditModel = !isPicWordEditState;
//
//
//       break;
//     case 3://我的收藏-话题
//       bool isTagEditState = ctx.state.isTagEditModel;
//       ctx.state.isTagEditModel = !isTagEditState;
//
//
//       break;
//   }
//   ctx.dispatch(MyFavoriteActionCreator.updateUI());
// }

void _dispose(Action action, Context<MyFavoriteState> ctx) {
  ctx.state.tabController?.dispose();
}
