import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net/api.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/base_response.dart';
import 'package:flutter_app/model/common_list_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/user/video_user_center/action.dart';
import 'package:flutter_app/page/user/video_user_center/model/refresh_model.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/page/video/video_item_commponent/state.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:wakelock/wakelock.dart';
import 'action.dart';
import 'state.dart';

final _tag = "subPlayList";
Effect<SubPlayListState> buildEffect() {
  return combineEffects(<Object, Effect<SubPlayListState>>{
    SubPlayListAction.loadDataAction: _loadData,
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    SubPlayListAction.onRefreshFollowStatus: _onRefreshFollowStatus,
    SubPlayListAction.goVideoPlayList: _goVideoPlayList,
  });
}

_onRefreshFollowStatus(Action action, Context<SubPlayListState> ctx) {
  Map<String, dynamic> map = action.payload;
  bool isUpdate = false;
  int uid = map['uid'];
  for (var value in ctx.state.videoList) {
    if (value.videoModel.publisher.uid == uid &&
        value.videoModel.publisher.hasFollowed != map['isFollow']) {
      VideoItemState newState = value.clone();
      newState.videoModel.publisher.hasFollowed = map['isFollow'];
      isUpdate = true;
      ctx.state.videoList[ctx.state.videoList.indexOf(value)] = newState;
    }
  }
  if (isUpdate) {
    ctx.dispatch(SubPlayListActionCreator.refreshFollowStatus());
  }
}

WillPopCallback _popCallback = () async {
  return true;
};

_initState(Action action, Context<SubPlayListState> ctx) {
  try {
    Wakelock.enable();
  } catch (e) {
    l.e("recommend_list", "_initData()...error:$e");
  }

  if (ctx.state.needLoad && ctx.state.hasNext) {
    _loadData(action, ctx);
  }
  ctx.state.tabController.addListener(() {
    if (ctx.state.tabController.indexIsChanging) return;
    var _curPageIndex = ctx.state.tabController.index;
    // ModalRoute<dynamic> _route =
    if (_curPageIndex == 1) {
      // 参考WillPopScope不允许返回手势
      ModalRoute.of(ctx.context)?.addScopedWillPopCallback(_popCallback);
    } else {
      ModalRoute.of(ctx.context)?.removeScopedWillPopCallback(_popCallback);
    }

    var uid = 0;
    if (ArrayUtil.isNotEmpty(ctx.state?.videoList) &&
        ctx.state.curVideoIndex >= 0) {
      uid = ctx.state.videoList[ctx.state.curVideoIndex]?.videoModel?.publisher
              ?.uid ??
          0;
    }
    var uniqueId = ctx.state.uniqueId;
    l.i("subplaylist",
        "endDrawer:${_curPageIndex == 1} uid:$uid uniqueId:$uniqueId");
    if (_curPageIndex == 1) {
      //进入了个人中心
      var refreshModel = RefreshModel();
      refreshModel.uid = uid;
      refreshModel.videoModel =
          ctx.state.videoList[ctx.state.curVideoIndex]?.videoModel;
      l.i("subplaylist",
          '============>ads:${refreshModel?.videoModel?.linkUrl}');
      refreshModel.uniqueId = uniqueId;
      ctx.broadcast(VideoUserCenterActionCreator.onUpdateUid(refreshModel));
      autoPlayModel.disposeAll();
    } else {
      autoPlayModel.startAvailblePlayer();
    }
  });

  autoPlayModel.registVideoListType(
      ExtVideoListType(VideoListType.SECOND, ctx.state.uniqueId));

  ctx.state.autoPlayListener = () {
    var curType = autoPlayModel.extVideoListType;
    if (!autoPlayModel.enable()) {
      l.i(_tag, "恢复播放在type:$curType，但是被禁止了");
      return;
    }
    l.i(_tag,
        "恢复播放在type:${curType.type} uniqueId:${curType.uniqueId} our type:${ctx.state.type} uniqueId:${ctx.state.uniqueId}，index:${ctx.state.curVideoIndex}");
    if (curType.type == ctx.state.type &&
        ctx.state.uniqueId == curType.uniqueId) {
      // 调用了开始播放
      // var localUrl = getLocalUrl(ctx.state.videoModel.sourceURL);
      // ||autoPlayModel.curDataSource != localUrl
      // if (autoPlayModel.curUniqueId != ctx.state.uniqueId) {
      //   l.i(_tag, "恢复播放在type:${ctx.state.type}，但是数据源不同了");
      //   return;
      // }
      l.i(_tag,
          "恢复播放在type:${ctx.state.type} uniqueId:${ctx.state.uniqueId}，index:${ctx.state.curVideoIndex}");
      // _checkOrPlay(ctx, autoPlayModel.curPlayCtrl, ctx.state.videoModel);
      ctx.dispatch(
          SubPlayListActionCreator.setAutoPlayIndex(ctx.state.curVideoIndex));
    } else {
      l.i(_tag, "恢复播放失败");
      ctx.dispatch(SubPlayListActionCreator.setAutoPlayIndex(-1));
    }
  };
  autoPlayModel.addExListener(ctx.context, ctx.state.autoPlayListener);
  
  Future.delayed(Duration(milliseconds: 200),(){
   // eaglePage(ctx.state.selfId(),
         // sourceId: ctx.state.eagleId(ctx.context));
  });
}

_dispose(Action action, Context<SubPlayListState> ctx) {
  autoPlayModel.removeExListener(ctx.context, ctx.state.autoPlayListener);
  ctx.state.autoPlayListener = null;
  Config.isNewListRequest = false;
  autoPlayModel.popVideoListType();
  if (ctx.state.videoList[ctx.state.curVideoIndex].videoModel.isVideo()) {
    autoPlayModel.disposeAll();
    // autoPlayModel.pauseAll();
  }
}


// 获取服务器时间
Future<String> _getReqDate() async {
  String reqDate;
  try {
    reqDate = (await netManager.client.getReqDate()).sysDate;
  } catch (e) {
    l.e("tag", "_onRefresh()...error:$e");
  }
  if (TextUtil.isEmpty(reqDate)) {
    reqDate = (netManager.getFixedCurTime().toString());
  }
  return reqDate;
}

///加载更多数据
_loadData(Action action, Context<SubPlayListState> ctx) async {
  if (ctx.state.isLoading) {
    return;
  }
  ctx.state.isLoading = true;
  ctx.state.requestParam["pageNumber"] = ctx.state.pageNumber + 1;
  ctx.state.requestParam["pageSize"] = ctx.state.pageSize;

  if(Config.isNewListRequest){
    String reqDate = await _getReqDate();
    ctx.state.requestParam.remove("type");
    ctx.state.requestParam.remove("subType");
    ctx.state.requestParam["tag"] = Config.isNewListRequestId;
    ctx.state.requestParam["reqDate"] = reqDate;
    ctx.state.requestParam["isPopping"] = true;
  }

  BaseResponse baseResponse;
  if (ctx.state.playType == VideoPlayConfig.VIDEO_FIND ||
      ctx.state.playType == VideoPlayConfig.HOT_VIDEO_FIND ||
      ctx.state.playType == VideoPlayConfig.VIDEO_MORE_SEARCH ||
      ctx.state.playType == VideoPlayConfig.VIDEO_TYPE_ZONE) {
    baseResponse = await HttpManager()
        .post(ctx.state.requestUrl, params: ctx.state.requestParam);
  } else {
    baseResponse = await HttpManager()
        .get(ctx.state.requestUrl, params: ctx.state.requestParam);
  }
  if (baseResponse?.code == 200 ?? false) {
    /// 使用PagedList
    ctx.state.pageNumber++;
    CommonListModel commonListModel =
        CommonListModel.fromJson(baseResponse.data);
    if ((commonListModel?.list?.length ?? 0) > 0) {
      List<VideoItemState> itemStateList = [];
      for (int iLoop = 0; iLoop < commonListModel.list.length; iLoop++) {
        VideoModel model = commonListModel.list[iLoop];
        VideoItemState itemState = VideoItemState(videoModel: model);
        itemState.index = iLoop;
        itemState.type = VideoListType.SECOND;
        itemState.uniqueId =
            "_uniqueId_in_type_${itemState.type}_at_index_${itemState.index}";
        itemState.enablePlay.value = (iLoop == ctx.state.curVideoIndex);
        itemStateList.add(itemState);
      }
      ctx.state.hasNext =
          null != action.payload ? (action.payload['hasNext'] ?? false) : false;

      ctx.dispatch(SubPlayListActionCreator.onLoadSuccess());
    }
    // 不再提示-没有更多
    // else {
    //   showToast(msg: Lang.NO_MORE);
    // }
  } else {
    if(!ctx.state.requestUrl.contains("tag/vid/list")){
      showToast(msg: Lang.SERVER_ERROR);
    }
  }
  ctx.state.isLoading = false;
}

/// 前往视频播放列表
_goVideoPlayList(Action action, Context<SubPlayListState> ctx) {
  if (ctx.state.tabController.index != 0) {
    ctx.state.tabController.animateTo(0);
  }
}
