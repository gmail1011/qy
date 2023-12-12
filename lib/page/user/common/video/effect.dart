import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/local_store/cache_video_model.dart';
import 'package:flutter_app/common/local_store/cached_history_video_store.dart';
import 'package:flutter_app/common/local_store/cached_video_store.dart';
import 'package:flutter_app/common/net/api.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/base_response.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/model/video_paged_list.dart';
import 'package:flutter_app/page/setting/my_favorite/action.dart';
import 'package:flutter_app/page/user/history_records/action.dart';
import 'package:flutter_app/page/user/offline_cache/action.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_base/flutter_base.dart';

import '../module_type.dart';
import 'action.dart';
import 'state.dart';

Effect<LongVideoState> buildEffect() {
  return combineEffects(<Object, Effect<LongVideoState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    LongVideoAction.refresh: _initState,
    LongVideoAction.loadMore: _loadMoreVideoList,
    LongVideoAction.deleteVideo: _deleteVideo,
    LongVideoAction.collectBatch:collectBatch,
    MyFavoriteAction.changeEditState: _changeEditState,
    MyFavoriteAction.clearEditState: _clearEditState,
    OfflineCacheAction.changeEditState: _changeEditState,
    OfflineCacheAction.clearEditState: _clearEditState,
    HistoryRecordsAction.changeEditState: _changeEditState,
    HistoryRecordsAction.clearEditState: _clearEditState,
  });
}

void _initState(Action action, Context<LongVideoState> ctx) {
  ctx.state.videoPageNumber = 1;
  _refreshLongVideoList(ctx);
}

///刷新视频列表
void _refreshLongVideoList(Context<LongVideoState> ctx) {
  if (ctx.state.moduleType == null) {
    return;
  }
  if (ctx.state.moduleType == ModuleType.LONG_VIDEO_MY_PURCHASES) {
    _longBuyVideoReq(ctx);
  } else if (ctx.state.moduleType == ModuleType.LONG_VIDEO_MY_FAVORITE) {
    _longFavoriteVideoReq(ctx);
  } else if (ctx.state.moduleType == ModuleType.LONG_VIDEO_HISTORY_RECORDS) {
    _getCacheVideoList(ctx, ModuleType.LONG_VIDEO_HISTORY_RECORDS);
  } else if (ctx.state.moduleType == ModuleType.LONG_VIDEO_OFFLINE_CACHE) {
    _getCacheVideoList(ctx, ModuleType.LONG_VIDEO_OFFLINE_CACHE);
  }
}

///我的购买
void _longBuyVideoReq(Context<LongVideoState> ctx) async {
  int pageNumber = ctx.state.videoPageNumber;
  int pageSize = ctx.state.pageSize;
  int uid = GlobalStore.getMe()?.uid;

  try {
    MineVideo works =
        await netManager.client.getMineBuy(pageSize, pageNumber, "MOVIE", uid);
    if ((works?.list ?? []).isNotEmpty) {
      ctx.state.hasNext = works.hasNext;
      if (pageNumber == 1) {
        ctx.state.videoModelList.clear();
      }
      ctx.state.videoModelList.addAll(works?.list);
      ctx.state.requestController.requestSuccess();
      if (pageNumber == 1) {
        ctx.state.refreshController?.refreshCompleted(resetFooterState: true);
      } else {
        ctx.state.refreshController?.loadComplete();
      }
    } else {
      if (ctx.state.videoModelList?.isEmpty ?? false) {
        ctx.state.requestController.requestDataEmpty();
      } else {
        ctx.state.refreshController.loadNoData();
      }
    }
  } catch (e) {
    if (ctx.state.videoModelList?.isEmpty ?? false) {
      ctx.state.requestController.requestFail();
    } else {
      ctx.state.refreshController.loadFailed();
    }
  }
  ctx.dispatch(LongVideoActionCreator.updateUI());
}

///请求长视频列表
void _longFavoriteVideoReq(Context<LongVideoState> ctx) async {
  try {
    Map<String, dynamic> reqMapParams = {};
    reqMapParams['type'] = 'movie';
    reqMapParams['pageNumber'] = ctx.state.videoPageNumber;
    reqMapParams['pageSize'] = ctx.state.pageSize;
    reqMapParams['uid'] = GlobalStore.getMe()?.uid ?? 0;
    BaseResponse res =
        await HttpManager().get(Address.MY_FAVORITE, params: reqMapParams);

    if (res.code == 200) {
      PagedList list = PagedList.fromJson(res.data);
      ctx.state.hasNext = res.data["hasNext"] ?? false;

      List<VideoModel> modelList = VideoModel.toList(list.list);
      if (ctx.state.videoPageNumber == 1) {
        ctx.state.videoModelList?.clear();
      }

      if ((modelList ?? []).isNotEmpty) {
        ctx.state.videoModelList?.addAll(modelList);
        ctx.state.requestController.requestSuccess();
        if (ctx.state.videoPageNumber == 1) {
          ctx.state.refreshController?.refreshCompleted(resetFooterState: true);
        } else {
          ctx.state.refreshController?.loadComplete();
        }
      } else {
        if (ctx.state.videoModelList?.isEmpty ?? false) {
          ctx.state.requestController.requestDataEmpty();
        } else {
          ctx.state.refreshController.loadNoData();
        }
      }
    } else {
      if (ctx.state.videoModelList?.isEmpty ?? false) {
        ctx.state.requestController?.requestFail();
      } else {
        ctx.state.refreshController?.loadFailed();
      }
    }
  } catch (e) {
    if (ctx.state.videoModelList?.isEmpty ?? false) {
      ctx.state.requestController.requestFail();
    } else {
      ctx.state.refreshController.loadFailed();
    }
  }
  ctx.dispatch(LongVideoActionCreator.updateUI());
}

///加载更多视频列表
void _loadMoreVideoList(Action action, Context<LongVideoState> ctx) {
  if (ctx.state.videoPageNumber * ctx.state.pageSize <=
      ctx.state.videoModelList.length) {
    ctx.state.videoPageNumber = ctx.state.videoPageNumber + 1;
    _refreshLongVideoList(ctx);
  } else {
    ctx.state.refreshController?.loadNoData();
  }
}

///接收编辑状态
void _changeEditState(Action action, Context<LongVideoState> ctx) {
  int index = action.payload as int;
  print("长视频编辑状态-$index");
  if (index == 0) {
    bool isVideoEditState = ctx.state.isVideoEditModel;
    ctx.state.isVideoEditModel = !isVideoEditState;
    ctx.dispatch(LongVideoActionCreator.updateUI());
  }
}

///接收编辑状态
void _clearEditState(Action action, Context<LongVideoState> ctx) {
  int index = action.payload as int;
  print("长视频编辑状态-$index");
  if (index != 0 && ctx.state.isVideoEditModel ?? false) {
    ctx.state.isVideoEditModel = false;
    ctx.dispatch(LongVideoActionCreator.updateUI());
  }
}

///获取缓存列表
void _getCacheVideoList(
    Context<LongVideoState> ctx, ModuleType moduleType) async {
  try {
    await Future.delayed(Duration(milliseconds: 500));

    List<CachedVideoModel> list = [];
    if (moduleType == ModuleType.LONG_VIDEO_OFFLINE_CACHE) {
      list = await CachedVideoStore().getCachedVideosByType(CACHED_TYPE_FILM);
    } else if (moduleType == ModuleType.LONG_VIDEO_HISTORY_RECORDS) {
      list = await CachedHistoryVideoStore()
          .getCachedHistoryVideosByType(HISTORY_CACHED_FILM);
    } else {
      return;
    }

    if (list.isEmpty) {
      ctx.state.requestController.requestDataEmpty();
    } else {
      var newList = list.map((item) => item.videoModel).toList();
      ctx.state.videoModelList.clear();
      ctx.state.videoModelList.addAll(newList);
      ctx.state.requestController.requestSuccess();
      if (ctx.state.videoModelList?.isEmpty ?? false) {
        ctx.state.requestController.requestDataEmpty();
      } else {
        //没有分页，刷新完成、加载更多完成
        ctx.state.refreshController?.refreshCompleted();
        ctx.state.refreshController?.loadNoData();
      }
    }
  } catch (e) {
    if (ctx.state.videoModelList?.isEmpty ?? false) {
      ctx.state.requestController?.requestFail();
    } else {
      ctx.state.refreshController?.loadFailed();
    }
  }
  ctx.dispatch(LongVideoActionCreator.updateUI());
}

///执行删除视频操作
void _deleteVideo(Action action, Context<LongVideoState> ctx) async {
  if (ctx.state.moduleType == null) {
    return;
  }
  if (ctx.state.moduleType == ModuleType.LONG_VIDEO_MY_PURCHASES) {
  } else if (ctx.state.moduleType == ModuleType.LONG_VIDEO_MY_FAVORITE) {
    _deleteMyFavotiteVideo(action, ctx);
  } else if (ctx.state.moduleType == ModuleType.LONG_VIDEO_HISTORY_RECORDS) {
    _deleteCacheVideo(action, ctx, ModuleType.LONG_VIDEO_HISTORY_RECORDS);
  } else if (ctx.state.moduleType == ModuleType.LONG_VIDEO_OFFLINE_CACHE) {
    _deleteCacheVideo(action, ctx, ModuleType.LONG_VIDEO_OFFLINE_CACHE);
  }
}


///批量删除视频操作
void collectBatch(Action action, Context<LongVideoState> ctx) async {
  if (ctx.state.moduleType == null) {
    return;
  }
  if (ctx.state.moduleType == ModuleType.LONG_VIDEO_MY_FAVORITE) {

    try {
      WBLoadingDialog.show(ctx.context);
      List<String> videoIds = action.payload;
      var response = await netManager.client.collectBatch(videoIds, "movie",false);
      l.d("_collectVideo-response:", "$response");
      ctx.state.videoModelList?.clear();
      await Future.delayed(Duration(milliseconds: 500));
      _longFavoriteVideoReq(ctx);
      showToast(msg: "删除成功~");
      WBLoadingDialog.dismiss(ctx.context);

    } catch (e) {
      showToast(msg: "删除视频失败:$e");
      WBLoadingDialog.dismiss(ctx.context);
    }
  }
}


///删除(取消)收藏视频
void _deleteMyFavotiteVideo(Action action, Context<LongVideoState> ctx) async {
  try {
    WBLoadingDialog.show(ctx.context);
    String videoId = action.payload as String;
    var response = await netManager.client.changeTagStatus(videoId, false, "movie");
    l.d("_collectVideo-response:", "$response");

    ctx.state.videoModelList?.clear();
    await Future.delayed(Duration(milliseconds: 500));
    _longFavoriteVideoReq(ctx);
    showToast(msg: "删除成功~");
    WBLoadingDialog.dismiss(ctx.context);

  } catch (e) {
    showToast(msg: "删除视频失败:$e");
    WBLoadingDialog.dismiss(ctx.context);
  }
}

///删除缓存视频
void _deleteCacheVideo(
    Action action, Context<LongVideoState> ctx, ModuleType moduleType) async {
  try {
    WBLoadingDialog.show(ctx.context);
    String videoId = action.payload as String;
    if (moduleType == ModuleType.LONG_VIDEO_HISTORY_RECORDS) {
      //删除长视频历史记录
      await CachedHistoryVideoStore().deleteBatch([videoId]);
    } else if (moduleType == ModuleType.LONG_VIDEO_OFFLINE_CACHE) {
      //删除长视频离线缓存
      await CachedVideoStore().deleteBatch([videoId]);
    } else {
      WBLoadingDialog.dismiss(ctx.context);
      return;
    }

    await Future.delayed(Duration(milliseconds: 500));
    _getCacheVideoList(ctx, moduleType);
    showToast(msg: "删除成功～");
    WBLoadingDialog.dismiss(ctx.context);
  } catch (e) {
    showToast(msg: "删除失败~:\n$e");
    WBLoadingDialog.dismiss(ctx.context);
  }
}

void _dispose(Action action, Context<LongVideoState> ctx) {
  WBLoadingDialog.dismiss(ctx.context);
  ctx.state.videoModelList?.clear();
  ctx.state.videoModelList = null;
  ctx.state.requestController = null;

  ctx.state.refreshController?.dispose();
}
