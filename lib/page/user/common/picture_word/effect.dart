import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net/api.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/model/video_paged_list.dart';
import 'package:flutter_app/page/setting/my_favorite/action.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

import '../module_type.dart';
import 'action.dart';
import 'state.dart';

Effect<PictureWordState> buildEffect() {
  return combineEffects(<Object, Effect<PictureWordState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    MyFavoriteAction.changeEditState: _changeEditState,
    MyFavoriteAction.clearEditState: _clearEditState,
    PictureWordAction.doLike: _doLike,
    PictureWordAction.refreshVideo: _initState,
    PictureWordAction.picListLoadMore: _picListLoadMore,
    PictureWordAction.forward: _forwardVideo,
    PictureWordAction.operateCollect: _operateCollect,
    PictureWordAction.delCollect: _delCollect,
    PictureWordAction.collectBatch: collectBatch,
    PictureWordAction.followUser: _followUser,
  });
}

void _initState(Action action, Context<PictureWordState> ctx) async {
  _refreshPicList(ctx);
}

void _refreshPicList(Context<PictureWordState> ctx) {
  if (ctx.state.moduleType == null) {
    return;
  }
  ctx.state.picturePageNumber = 1;
  if (ctx.state.moduleType == ModuleType.PICTRUE_WORD_MY_PURCHASES) {
    _loadBuyPicData(ctx);
  }
  if (ctx.state.moduleType == ModuleType.PICTRUE_WORD_MY_FAVORITE) {
    _loadFavoriteData(ctx);
  }
}

///我的购买
void _loadBuyPicData(Context<PictureWordState> ctx) async {
  int pageNumber = ctx.state.picturePageNumber;
  int pageSize = ctx.state.pageSize;
  int uid = GlobalStore.getMe()?.uid;

  try {
    MineVideo works =
        await netManager.client.getMineBuy(pageSize, pageNumber, "COVER", uid);
    if ((works?.list ?? []).isNotEmpty) {
      if (pageNumber == 1) {
        ctx.state.pictureVideoModelList.clear();
      }
      ctx.state.pictureVideoModelList?.addAll(works?.list);
      ctx.state.requestController.requestSuccess();
      if (ctx.state.picturePageNumber == 1) {
        ctx.state.refreshController?.refreshCompleted(resetFooterState: true);
      } else {
        ctx.state.refreshController?.loadComplete();
      }
    } else {
      if (ctx.state.pictureVideoModelList?.isEmpty ?? false) {
        ctx.state.requestController.requestDataEmpty();
      } else {
        ctx.state.refreshController.loadNoData();
      }
    }
  } catch (e) {
    if (ctx.state.pictureVideoModelList?.isEmpty ?? false) {
      ctx.state.requestController?.requestFail();
    } else {
      ctx.state.refreshController?.loadFailed();
    }
  }
  ctx.dispatch(PictureWordActionCreator.updateUI());
}

///请求刷新图文列表
void _loadFavoriteData(Context<PictureWordState> ctx) async {
  try {
    Map<String, dynamic> reqMapParams = {};
    reqMapParams['type'] = 'img';
    reqMapParams['pageNumber'] = ctx.state.picturePageNumber;
    reqMapParams['pageSize'] = ctx.state.pageSize;
    reqMapParams['uid'] = GlobalStore.getMe()?.uid ?? 0;
    var res =
        await HttpManager().get(Address.MY_FAVORITE, params: reqMapParams);

    if (res.code == 200) {
      PagedList list = PagedList.fromJson(res.data);
      ctx.state.hasNext = res.data["hasNext"] ?? false;

      List<VideoModel> modelList = VideoModel.toList(list.list);
      if (ctx.state.picturePageNumber == 1) {
        ctx.state.pictureVideoModelList?.clear();
      }

      if ((modelList ?? []).isNotEmpty) {
        ctx.state.pictureVideoModelList?.addAll(modelList);
        ctx.state.requestController?.requestSuccess();

        if (ctx.state.picturePageNumber == 1) {
          ctx.state.refreshController?.refreshCompleted(resetFooterState: true);
        } else {
          ctx.state.refreshController?.loadComplete();
        }
      } else {
        if (ctx.state.pictureVideoModelList?.isEmpty ?? false) {
          ctx.state.requestController.requestDataEmpty();
        } else {
          ctx.state.refreshController.loadNoData();
        }
      }
    } else {
      if (ctx.state.pictureVideoModelList?.isEmpty ?? false) {
        ctx.state.requestController?.requestFail();
      } else {
        ctx.state.refreshController?.loadFailed();
      }
    }
  } catch (e) {
    l.d("_picListReq-error", "$e");
    if (ctx.state.pictureVideoModelList?.isEmpty ?? false) {
      ctx.state.requestController.requestFail();
    } else {
      ctx.state.refreshController.loadFailed();
    }
  }
  ctx.dispatch(PictureWordActionCreator.updateUI());
}

///请求图文列表
void _picListLoadMore(Action action, Context<PictureWordState> ctx) async {
  if (ctx.state.picturePageNumber * ctx.state.pageSize <=
      ctx.state.pictureVideoModelList?.length) {
    ctx.state.picturePageNumber = ctx.state.picturePageNumber + 1;
    if (ctx.state.moduleType == ModuleType.PICTRUE_WORD_MY_PURCHASES) {
      _loadBuyPicData(ctx);
    }
    if (ctx.state.moduleType == ModuleType.PICTRUE_WORD_MY_FAVORITE) {
      _loadFavoriteData(ctx);
    }
  } else {
    ctx.state.refreshController?.loadNoData();
  }
}

///修改编辑状态
void _changeEditState(Action action, Context<PictureWordState> ctx) {
  int index = action.payload as int;
  print("图文编辑状态-$index");
  if (index == 2) {
    bool isPicEditState = ctx.state.isPicWordEditModel;
    ctx.state.isPicWordEditModel = !isPicEditState;
    ctx.dispatch(PictureWordActionCreator.updateUI());
  }
}

///清除编辑状态
void _clearEditState(Action action, Context<PictureWordState> ctx) {
  int index = action.payload as int;
  print("图文编辑状态-$index");
  if (index != 2 && ctx.state.isPicWordEditModel ?? false) {
    ctx.state.isPicWordEditModel = false;
    ctx.dispatch(PictureWordActionCreator.updateUI());
  }
}

///执行点赞(取消)请求
void _doLike(Action action, Context<PictureWordState> ctx) async {
  try {
    Map map = action.payload as Map;
    String videoId = map["videoId"];
    bool isLiked = map["isLiked"];
    if (isLiked) {
      await netManager.client.cancelLike(videoId, "video");
    } else {
      await netManager.client.sendLike(videoId, "video");
    }
  } catch (e) {
    l.d("_doLike-error", "$e");
  }
}

///转发视频
void _forwardVideo(Action action, Context<PictureWordState> ctx) async {
  try {
    String videoId = action.payload as String;
    await netManager.client.forward(videoId);
    showToast(msg: "转发成功");
  } catch (e) {
    showToast(msg: "转发失败:$e");
  }
}

///操作收藏
void _operateCollect(Action action, Context<PictureWordState> ctx) async {
  Map mapParams = action.payload as Map;
  String videoId = mapParams["videoId"];
  bool hasCollected = mapParams["hasCollected"];
  try {
    await netManager.client.changeTagStatus(videoId, hasCollected, "img");
  } catch (e) {
    //showToast(msg: e.toString());
  }
}

///删除收藏图文
void _delCollect(Action action, Context<PictureWordState> ctx) async {
  try {
    WBLoadingDialog.show(ctx.context);
    String videoId = action.payload as String;
    await netManager.client.changeTagStatus(videoId, false, "img");
    await Future.delayed(Duration(milliseconds: 200));
    _refreshPicList(ctx);

    showToast(msg: "删除成功~");
    WBLoadingDialog.dismiss(ctx.context);
  } catch (e) {
    showToast(msg: e.toString());
    l.d("_delCollect-error", "$e");
    WBLoadingDialog.dismiss(ctx.context);
  }
}


///批量删除视频操作
void collectBatch(Action action, Context<PictureWordState> ctx) async {
  if (ctx.state.moduleType == null) {
    return;
  }
  if (ctx.state.moduleType == ModuleType.PICTRUE_WORD_MY_FAVORITE) {

    try {
      WBLoadingDialog.show(ctx.context);
      List<String> videoIds = action.payload;
      await netManager.client.collectBatch(videoIds, "img",false);
      await Future.delayed(Duration(milliseconds: 500));
      _refreshPicList(ctx);
      showToast(msg: "删除成功~");
      WBLoadingDialog.dismiss(ctx.context);

    } catch (e) {
      showToast(msg: "删除视频失败:$e");
      WBLoadingDialog.dismiss(ctx.context);
    }
  }
}

///关注
void _followUser(Action action, Context<PictureWordState> ctx) async {
  /// 用户uid
  try {
    int followUID = action.payload as int;
    await netManager.client.getFollow(followUID, true);
    ctx.state.pictureVideoModelList.forEach((element) {
      if (followUID == element.publisher?.uid) {
        element.publisher?.hasFollowed = true;
      }
    });

    ctx.dispatch(PictureWordActionCreator.updateUI());
    showToast(msg: "关注成功～");
  } catch (e) {
    l.d('getFollow', e.toString());
    showToast(msg: e.toString() ?? '');
  }
}

void _dispose(Action action, Context<PictureWordState> ctx) {
  WBLoadingDialog.dismiss(ctx.context);
  ctx.state.pictureVideoModelList?.clear();
  ctx.state.pictureVideoModelList = null;
  ctx.state.requestController = null;

  ctx.state.refreshController?.dispose();
}
