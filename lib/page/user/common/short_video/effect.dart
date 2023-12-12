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
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

import '../module_type.dart';
import 'action.dart';
import 'state.dart';

Effect<ShortVideoState> buildEffect() {
  return combineEffects(<Object, Effect<ShortVideoState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    ShortVideoAction.refresh: _initState,
    ShortVideoAction.loadMore: _loadMoreVideoList,
    ShortVideoAction.deleteVideo: _deleteVideo,
    ShortVideoAction.collectBatch:collectBatch,
    MyFavoriteAction.changeEditState: _changeEditState,
    MyFavoriteAction.clearEditState: _clearEditState,
    OfflineCacheAction.changeEditState: _changeEditState,
    OfflineCacheAction.clearEditState: _clearEditState,
    HistoryRecordsAction.changeEditState: _changeEditState,
    HistoryRecordsAction.clearEditState: _clearEditState,
  });
}

void _initState(Action action, Context<ShortVideoState> ctx) {
  ctx.state.videoPageNumber = 1;
  _refreshShortVideoList(ctx);
}

void _refreshShortVideoList(Context<ShortVideoState> ctx) {
  if (ctx.state.moduleType == null) {
    return;
  }
  if (ctx.state.moduleType == ModuleType.SHORT_VIDEO_MY_PURCHASES) {
    _shortBuyVideoReq(ctx);
  } else if (ctx.state.moduleType == ModuleType.SHORT_VIDEO_MY_FAVORITE) {
    _shortFavoriteVideoReq(ctx);
  } else if (ctx.state.moduleType == ModuleType.SHORT_VIDEO_HISTORY_RECORDS) {
    _getCacheVideoList(ctx, ModuleType.SHORT_VIDEO_HISTORY_RECORDS);
  } else if (ctx.state.moduleType == ModuleType.SHORT_VIDEO_OFFLINE_CACHE) {
    _getCacheVideoList(ctx, ModuleType.SHORT_VIDEO_OFFLINE_CACHE);
  }
}

///请求收藏短视频列表
void _shortFavoriteVideoReq(Context<ShortVideoState> ctx) async {
  try {
    Map<String, dynamic> reqMapParams = {};
    reqMapParams['type'] = 'video';
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
      ctx.state.requestController?.requestFail();
    } else {
      ctx.state.refreshController?.loadFailed();
    }
  }
  ctx.dispatch(ShortVideoActionCreator.updateUI());
}

///我的购买
void _shortBuyVideoReq(Context<ShortVideoState> ctx) async {
  int pageNumber = ctx.state.videoPageNumber;
  int pageSize = ctx.state.pageSize;
  int uid = GlobalStore.getMe()?.uid;

  try {
    MineVideo works =
        await netManager.client.getMineBuy(pageSize, pageNumber, "SP", uid);
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
  ctx.dispatch(ShortVideoActionCreator.updateUI());
}

///加载更多视频列表
void _loadMoreVideoList(Action action, Context<ShortVideoState> ctx) {
  if (ctx.state.videoPageNumber * ctx.state.pageSize <=
      ctx.state.videoModelList.length) {
    ctx.state.videoPageNumber = ctx.state.videoPageNumber + 1;
    _shortFavoriteVideoReq(ctx);
  } else {
    ctx.state.refreshController?.loadNoData();
  }
}

///监听短视频编辑状态
void _changeEditState(Action action, Context<ShortVideoState> ctx) {
  int index = action.payload as int;
  print("短视频编辑状态-$index");
  if (index == 1) {
    bool isVideoEditState = ctx.state.isVideoEditModel;
    ctx.state.isVideoEditModel = !isVideoEditState;
    ctx.dispatch(ShortVideoActionCreator.updateUI());
  }
}

///监听短视频编辑状态
void _clearEditState(Action action, Context<ShortVideoState> ctx) {
  int index = action.payload as int;
  print("短视频编辑状态-$index");
  if (index != 1 && ctx.state.isVideoEditModel ?? false) {
    ctx.state.isVideoEditModel = false;
    ctx.dispatch(ShortVideoActionCreator.updateUI());
  }
}

///获取离线缓存列表/历史记录缓存列表
void _getCacheVideoList(
    Context<ShortVideoState> ctx, ModuleType moduleType) async {
  try {
    l.d("查询视频缓存列表：", "$moduleType");
    await Future.delayed(Duration(milliseconds: 500));
    List<CachedVideoModel> list = [];
    if (moduleType == ModuleType.SHORT_VIDEO_OFFLINE_CACHE) {
      list = await CachedVideoStore().getCachedVideosByType(CACHED_TYPE_SHORT);
    } else if (moduleType == ModuleType.SHORT_VIDEO_HISTORY_RECORDS) {
      list = await CachedHistoryVideoStore()
          .getCachedHistoryVideosByType(HISTORY_CACHED_SHORT);
    } else {
      return;
    }

    if (list.isEmpty) {
      ctx.state.requestController.requestDataEmpty();
    } else {
      var newList = list.map((item) => item.videoModel).toList();
      ctx.state.videoModelList?.clear();
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
    ctx.state.requestController.requestFail();
  }
  ctx.dispatch(ShortVideoActionCreator.updateUI());
}

///执行删除视频操作
void _deleteVideo(Action action, Context<ShortVideoState> ctx) async {
  if (ctx.state.moduleType == null) {
    return;
  }
  if (ctx.state.moduleType == ModuleType.SHORT_VIDEO_MY_PURCHASES) {
  } else if (ctx.state.moduleType == ModuleType.SHORT_VIDEO_MY_FAVORITE) {
    _deleteMyFavotiteVideo(action, ctx);
  } else if (ctx.state.moduleType == ModuleType.SHORT_VIDEO_HISTORY_RECORDS) {
    _deleteCacheVideo(action, ctx, ModuleType.SHORT_VIDEO_HISTORY_RECORDS);
  } else if (ctx.state.moduleType == ModuleType.SHORT_VIDEO_OFFLINE_CACHE) {
    _deleteCacheVideo(action, ctx, ModuleType.SHORT_VIDEO_OFFLINE_CACHE);
  }
}

///批量删除操作
void collectBatch(Action action, Context<ShortVideoState> ctx) async {
  if (ctx.state.moduleType == null) {
    return;
  }
  if (ctx.state.moduleType == ModuleType.SHORT_VIDEO_MY_FAVORITE) {

    try {
      WBLoadingDialog.show(ctx.context);
      List<String> videoIds = action.payload;
      var response = await netManager.client.collectBatch(videoIds, "video",false);
      l.d("_collectVideo-response:", "$response");
      ctx.state.videoModelList?.clear();
      await Future.delayed(Duration(milliseconds: 500));
      _shortFavoriteVideoReq(ctx);
      showToast(msg: "删除成功~");
      WBLoadingDialog.dismiss(ctx.context);

    } catch (e) {
      showToast(msg: "删除视频失败:$e");
      WBLoadingDialog.dismiss(ctx.context);
    }
  }
}

///删除缓存视频、删除历史缓存视频
void _deleteCacheVideo(
    Action action, Context<ShortVideoState> ctx, ModuleType moduleType) async {
  try {
    l.d("执行删除视频操作：", "$moduleType");
    WBLoadingDialog.show(ctx.context);
    String videoId = action.payload as String;
    if (moduleType == ModuleType.SHORT_VIDEO_HISTORY_RECORDS) {
      //删除短视频历史记录
      await CachedHistoryVideoStore().deleteBatch([videoId]);
    } else if (moduleType == ModuleType.SHORT_VIDEO_OFFLINE_CACHE) {
      //删除短视频离线缓存
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
    l.d("删除失败", "$e");
    showToast(msg: "删除失败～\n:$e");
    WBLoadingDialog.dismiss(ctx.context);
  }
}

///删除(取消)收藏视频
void _deleteMyFavotiteVideo(Action action, Context<ShortVideoState> ctx) async {
  try {
    WBLoadingDialog.show(ctx.context);
    String videoId = action.payload as String;
    var response =
        await netManager.client.changeTagStatus(videoId, false, "video");
    l.d("_collectVideo-response:", "$response");

    ctx.state.videoModelList?.clear();
    await Future.delayed(Duration(milliseconds: 500));
    _shortFavoriteVideoReq(ctx);
    showToast(msg: "删除成功~");
    WBLoadingDialog.dismiss(ctx.context);
  } catch (e) {
    showToast(msg: "删除失败:$e");
    WBLoadingDialog.dismiss(ctx.context);
  }
}

void _dispose(Action action, Context<ShortVideoState> ctx) {
  WBLoadingDialog.dismiss(ctx.context);
  ctx.state.videoModelList?.clear();
  ctx.state.videoModelList = null;
  ctx.state.requestController = null;
  ctx.state.refreshController?.dispose();
}
