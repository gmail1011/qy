import 'package:fbroadcast/fbroadcast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' as BaseEvn;
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/local_store/cached_video_store.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/topinfo/RankInfoModel.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/video/player_util.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart';
import 'package:flutter_app/widget/dialog/popup_view.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../global_store/store.dart';
import '../../../../alert/vip_rank_alert.dart';
import 'action.dart';
import 'state.dart';

Effect<FilmVideoIntroductionState> buildEffect() {
  return combineEffects(<Object, Effect<FilmVideoIntroductionState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    FilmVideoIntroductionAction.refreshData: _refreshData,
    FilmVideoIntroductionAction.loadMoreData: _loadMoreData,
    FilmVideoIntroductionAction.like: _operateLike,
    FilmVideoIntroductionAction.collect: _collectVideo,
    FilmVideoIntroductionAction.changeLine: _changeLine,
    FilmVideoIntroductionAction.cacheVideo: _cacheVideo,
    FilmVideoIntroductionAction.reloadNewVideo: _reloadNewVideo,
    FilmVideoIntroductionAction.doFollow: _doFollow,
  });
}

///初始化数据
void _initState(Action action, Context<FilmVideoIntroductionState> ctx) async {
  ctx.state.dataReq = true;

  for(int i=0;i<Address.cdnAddressLists.length;i++){
    DomainInfo domainInfo = Address.cdnAddressLists[i];
    PopModel popModel =PopModel(
        name: domainInfo.desc,
        fontSize:  Dimens.pt13,
        id: i);
    ctx.state.listPopModel.add(popModel);
  }
  ctx.state.domainInfo = Address.currentDomainInfo;
  CacheServer().setSelectLine(ctx.state.domainInfo.url);

  ///获取广告
  List<AdsInfoBean> list = await getAdvByType(7);
  ctx.state.adsList = (list ?? []);
  _refreshData(action, ctx);


  FBroadcast.instance().register(VariableConfig.refreshVideoInfo, (value, callback) {

    VideoModel videoModel = value;

    ctx.state.viewModel = videoModel;

    ctx.dispatch(FilmVideoIntroductionActionCreator.updateUI());

  });

  //获取话题信息
  // _loadRankInfo(action, ctx);
}

void _loadRankInfo(Action action, Context<FilmVideoIntroductionState> ctx) async{
  RankInfoModel rankInfoModel = await netManager.client.topInfo(ctx.state.viewModel?.id??0);
  ctx.state.rankInfoModel = rankInfoModel;
  ctx.dispatch(FilmVideoIntroductionActionCreator.updateUI());
}
///请求刷新数据
void _refreshData(
    Action action, Context<FilmVideoIntroductionState> ctx) async {
  try {
    l.e("FilmVideoIntroduction-->", "_refreshData");



    MineVideo works = await netManager.client.getRecommandVideoList(
        ctx.state.pageSize,
        1,
        "MOVIE",
        "new",
        ctx.state.viewModel?.publisher?.uid ?? 0);
    ctx.state.pageNum = 1;
    ctx.state.dataReq = false;

    ctx.state.hasNext = works.hasNext;
    ctx.state.videoList = [];
    ctx.state.videoList.addAll(Config.randomHotVideo());
    if ((works?.list ?? []).isNotEmpty) {
      ctx.state.videoList.addAll(works.list);
    }
    ctx.state.refreshController?.refreshCompleted(resetFooterState: true);
  } catch (e) {
    l.e("getRecommandVideoList-error:", "$e");
    ctx.state.refreshController?.refreshFailed();
  }
  ctx.dispatch(FilmVideoIntroductionActionCreator.updateUI());
}

///请求加载更多数据
void _loadMoreData(
    Action action, Context<FilmVideoIntroductionState> ctx) async {
  try {
    l.e("FilmVideoIntroduction-->", "_loadMoreData");
    if (!ctx.state.hasNext ?? false) {
      ctx.state.refreshController.loadNoData();
      return;
    }
    MineVideo works = await netManager.client.getRecommandVideoList(
        ctx.state.pageSize,
        ctx.state.pageNum + 1,
        "MOVIE",
        "new",
        ctx.state.viewModel?.publisher?.uid ?? 0);

    if (works != null) {
      ctx.state.hasNext = works.hasNext;
      if ((works?.list ?? []).isNotEmpty) {
        ctx.state.videoList?.addAll(works.list);
        ctx.state.pageNum++;
        ctx.state.refreshController?.loadComplete();
      } else {
        ctx.state.refreshController.loadNoData();
      }
    }
  } catch (e) {
    l.e("getRecommandVideoList-error:", "$e");
    ctx.state.refreshController?.loadFailed();
  }
  ctx.dispatch(FilmVideoIntroductionActionCreator.updateUI());
}

///操作点赞
void _operateLike(
    Action action, Context<FilmVideoIntroductionState> ctx) async {
  if (ctx.state.viewModel == null) {
    return;
  }

  try {
    bool hasLiked = ctx.state.viewModel?.vidStatus?.hasLiked ?? false;
    if (hasLiked) {
      var cancelResponse = await await netManager.client
          .cancelLike(ctx.state.viewModel?.id, "video");
      l.e("_operateLike-response:", "$cancelResponse");
      ctx.state.viewModel?.vidStatus?.hasLiked = false;
    } else {
      var response =
          await netManager.client.sendLike(ctx.state.viewModel?.id, "video");
      l.e("_operateLike-response:", "$response");

      ctx.state.viewModel?.vidStatus?.hasLiked = true;
    }
    ctx.dispatch(FilmVideoIntroductionActionCreator.updateUI());
  } catch (e) {
    l.e("_operateLike-error:", "$e");
  }
}

///收藏视频
void
_collectVideo(
    Action action, Context<FilmVideoIntroductionState> ctx) async {
  if (ctx.state.viewModel == null) {
    return;
  }

  try {
    bool hasCollected = ctx.state.viewModel?.vidStatus?.hasCollected ?? false;

    if (hasCollected) {
      var response = await netManager.client
          .changeTagStatus(ctx.state.viewModel?.id, false, "video");
      ctx.state.viewModel?.vidStatus?.hasCollected = false;
      l.e("_collectVideo-response:", "$response");
    } else {
      var response = await netManager.client
          .changeTagStatus(ctx.state.viewModel?.id, true, "video");
      l.e("_collectVideo-response:", "$response");
      ctx.state.viewModel?.vidStatus?.hasCollected = true;
    }
    ctx.dispatch(FilmVideoIntroductionActionCreator.updateUI());
  } catch (e) {
    l.e("_collectVideo-error:", "$e");
  }
}

///切换线路
void _changeLine(
    Action action, Context<FilmVideoIntroductionState> ctx) async {}

///缓存视频
void _cacheVideo(Action action, Context<FilmVideoIntroductionState> ctx) async {

  if (ctx.state.viewModel == null) {
    return;
  }

  // if (ctx.state.viewModel.isCoinVideo()) {
  //   if (needBuyVideo(ctx.state.viewModel)) {
  //     _onBuyProduct(action, ctx);
  //     return;
  //   }
  // }


  if (!GlobalStore.isVIP()) {
    VipRankAlert.show(
      ctx.context,
      type: VipAlertType.cache,
    );
    return;
  }

  bool isCached =
      CachedVideoStore().inCachedList(ctx.state.viewModel?.sourceURL);
  if (isCached) {
    showToast(msg: Lang.ALREADY_CACHED_TIP);
    return;
  }

  // ///检查今日是否已缓存10次视频
  // bool isCachedLimit = await CachedVideoStore().checkVideoCachedCountInToday();
  // if (isCachedLimit) {
  //   showToast(msg: "今日已缓存10次视频～");
  //   return;
  // }
  CachedVideoStore()
      .setCachedVideo(ctx.state.viewModel, cacheType: CACHED_TYPE_FILM);
  showToast(msg: "已加入缓存");

  int downloadCount  = GlobalStore.getWallet().downloadCount??0;
  var  walletModelEntity   = GlobalStore.getWallet();
  walletModelEntity.downloadCount = downloadCount-1;
  GlobalStore.refreshWalletOnlyDownloadCount(walletModelEntity);

  await netManager.client.useDownLoadCount();
}

///重新加载新视频，界面不退出
void _reloadNewVideo(
    Action action, Context<FilmVideoIntroductionState> ctx) async {
  try {
    VideoModel viewModel = action.payload as VideoModel;
    Map<String, dynamic> maps = Map();
    maps["videoId"] = viewModel?.id;
    /*BaseEvn.Navigator.of(ctx.context)
        .pushReplacement(BaseEvn.MaterialPageRoute(
      builder: (BaseEvn.BuildContext context) => FilmTvVideoDetailPage().buildPage(maps),
    ));*/

    FBroadcast.instance().broadcast(VariableConfig.refreshVideo,value: viewModel);


    return;

    // VideoModel viewModel = action.payload as VideoModel;
    // ctx.state.viewModel = viewModel;
    // ctx.dispatch(FilmVideoIntroductionActionCreator.updateUI());
    // ctx.broadcast(FilmVideoIntroductionActionCreator.notifyNewVideo(viewModel));
  } catch (e) {
    l.e("_collectVideo-error:", "$e");
  }
}








///执行关注操作
void _doFollow(Action action, Context<FilmVideoIntroductionState> ctx) async {
  try {
    bool isFollow = !ctx.state.viewModel.publisher.hasFollowed;
    ctx.dispatch(FilmVideoIntroductionActionCreator.updateFollowState(isFollow));
    int followUID = action.payload as int;
    await netManager.client.getFollow(followUID, isFollow);
  } catch (e) {
    l.d("执行关注操作错误", "$e");
  }
}

void _dispose(Action action, Context<FilmVideoIntroductionState> ctx) {
  ctx.state.refreshController?.dispose();
  FBroadcast.instance().dispose();
}
