import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/video_item_commponent/state.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:wakelock/wakelock.dart';
import 'action.dart';
import 'state.dart';

Effect<MainPlayerListState> buildEffect() {
  return combineEffects(<Object, Effect<MainPlayerListState>>{
    Lifecycle.initState: _initData,
    Lifecycle.dispose: _disposed,
    MainPlayerListAction.refreshData: _refreshData,
    MainPlayerListAction.loadMoreData: _loadMoreData,
    MainPlayerListAction.onRefreshFollowStatus: _onRefreshFollowStatus,
  });
}

_onRefreshFollowStatus(Action action, Context<MainPlayerListState> ctx) {
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
    ctx.dispatch(MainPlayerListActionCreator.refreshFollowStatus());
  }
}

bool isLoading = false;

///数据初始化
_initData(Action action, Context<MainPlayerListState> ctx) async {
  String _tag = "videolist";
  try {
    Wakelock.enable();
  } catch (e) {
    l.e("recommend_list", "_initData()...error:$e");
  }

  ///关注进入
  if (ctx.state.type == VideoListType.FOLLOW) {
    Future.delayed(Duration(milliseconds: 200), () async {
      await _refreshData(action, ctx);
    });
  } else if (ctx.state.type == VideoListType.RECOMMEND) {
    List<VideoModel> list = ctx.state.videoListModel.peekVideos;
    if (ArrayUtil.isEmpty(list)) {
      Future.delayed(Duration(milliseconds: 200), () async {
        await _refreshData(action, ctx);
      });
    } else {
      ctx.dispatch(MainPlayerListActionCreator.onRefreshListOkay(list));
    }
  }

  var adsList = await getAdsByType(AdsType.shortVideoFloating);
  if ((adsList?.length ?? 0) > 0) {
    ctx.dispatch(MainPlayerListActionCreator.showAdsOkay(adsList.first));
  }

  ctx.state.autoPlayListener = () {
    var curType = autoPlayModel.extVideoListType;
    if (!autoPlayModel.enable()) {
      l.i(_tag, "恢复播放在type:$curType，但是被禁止了");
      return;
    }
    // if (isMainPlayListInUc()) {
    //   l.i(_tag, "恢复播放在type:$curType，但是被禁止了");
    //   return;
    // }
    l.i(_tag,
        "恢复播放在type:${curType.type} our type:${ctx.state.type}，index:${ctx.state.curIndex}");
    if (curType.type == ctx.state.type) {
      // 调用了开始播放

      // var localUrl = getLocalUrl(ctx.state.videoModel.sourceURL);
      // ||autoPlayModel.curDataSource != localUrl
      // if (autoPlayModel.curUniqueId != ctx.state.uniqueId) {
      //   l.i(_tag, "恢复播放在type:${ctx.state.type}，但是数据源不同了");
      //   return;
      // }
      // l.i(_tag, "恢复播放在type:${ctx.state.type}，index:${ctx.state.curIndex}");
      // _checkOrPlay(ctx, autoPlayModel.curPlayCtrl, ctx.state.videoModel);
      l.i(_tag, "恢复播放在 type:${ctx.state.type}，index:${ctx.state.curIndex}");
      ctx.dispatch(
          MainPlayerListActionCreator.setAutoPlayIndex(ctx.state.curIndex));
      // Future.delayed(Duration(seconds: 1), () {
      // });
    } else {
      l.i(_tag, "${ctx.state.type},恢复播放失败 index:-1");
      ctx.dispatch(MainPlayerListActionCreator.setAutoPlayIndex(-1));
    }
  };
  autoPlayModel.addExListener(ctx.context, ctx.state.autoPlayListener);
  
  Future.delayed(Duration(milliseconds: 200),(){
    //eaglePage(ctx.state.selfId(),
          //sourceId: ctx.state.eagleId(ctx.context));
  });
}

_disposed(Action action, Context<MainPlayerListState> ctx) async {
  autoPlayModel.removeExListener(ctx.context, ctx.state.autoPlayListener);
  ctx.state.autoPlayListener = null;
}

///加载更多数据
_loadMoreData(Action action, Context<MainPlayerListState> ctx) async {
  if (ctx.state.isRequesting) {
    return;
  }
  l.i("videoList", "_loadMoreData()...");
  ctx.state.isRequesting = true;
  var list = await ctx.state.videoListModel.loadMoreList();
  ctx.state.isRequesting = false;
  if (ArrayUtil.isNotEmpty(list)) {
    l.i("videoList", "call onRefreshListOkay()...5");
    ctx.dispatch(MainPlayerListActionCreator.onRefreshListOkay(list));
  }
}

///刷新数据
_refreshData(Action action, Context<MainPlayerListState> ctx) async {
  // print("_refreshData()...type:${ctx.state.type}");

  if (ctx.state.isRequesting) {
    return;
  }

  ctx.state.videoList = [];
  ctx.dispatch(MainPlayerListActionCreator.onRefreshListOkay([]));
  ctx.state.isRequesting = true;
  var list = await ctx.state.videoListModel.refreshList();
  ctx.state.isRequesting = false;
  if (ArrayUtil.isNotEmpty(list)) {
    ctx.dispatch(MainPlayerListActionCreator.onRefreshListOkay(list));
  }
}
