import 'dart:math';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/manager/ad_Insert_manager.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/announce_liao_ba_entity.dart';
import 'package:flutter_app/model/res/common_post_res.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/guess_like_entity.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';

import 'community_recommend_action.dart';
import 'community_recommend_state.dart';

Effect<CommunityRecommendState> buildEffect() {
  return combineEffects(<Object, Effect<CommunityRecommendState>>{
    Lifecycle.initState: _onInitData,
    Lifecycle.dispose: _onDispose,
    CommunityRecommendAction.action: _onAction,
    CommunityRecommendAction.onLoadMore: _onLoadMore,
    CommunityRecommendAction.reqChangeDataList: _reqChangeDataList,
    CommunityRecommendAction.doFollow: _doFollow,
    CommunityRecommendAction.checkFollowUser: _checkFollowUser,
  });
}

///关注
void _doFollow(Action action, Context<CommunityRecommendState> ctx) async {
  try {
    Map map = action.payload as Map;
    int followUID = map["uid"];
    int changeDataIndex = map["changeDataIndex"];
    ctx.dispatch(CommunityRecommendActionCreator.updateFollowState(
        followUID, changeDataIndex));
    await netManager.client.getFollow(followUID, true);

    ///通知刷新所有推荐关注UI
    if (Config.followBlogger.containsKey(followUID)) {
      Config.followBlogger[followUID] = true;

      ctx.state.commonPostRes?.list?.forEach((element) {
        if (element.publisher?.uid != null &&
            Config.followBlogger.containsKey(element.publisher?.uid)) {
          element.publisher.hasFollowed =
              Config.followBlogger[element.publisher.uid];
        }
      });
    }
  } catch (e) {
    l.d("执行关注操作错误", "$e");
  }
}

void _onAction(Action action, Context<CommunityRecommendState> ctx) {}

void _onDispose(Action action, Context<CommunityRecommendState> ctx) {
  bus.off(EventBusUtils.refreshCommunity);
  ctx.state.refreshController?.dispose();
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

void _onInitData(Action action, Context<CommunityRecommendState> ctx) async {
  ///获取推荐列表banner 广告
  List<AdsInfoBean> adsList = await getAdsByType(AdsType.recommendType);
  ctx.dispatch(CommunityRecommendActionCreator.onAds(adsList));

  ///获取推荐列表中的广告
  List<AdsInfoBean> recommendListAdsList =
      await getAdsByType(AdsType.communityRecommend);
  ctx.dispatch(
      CommunityRecommendActionCreator.onRecommendListAds(recommendListAdsList));

  _onGetAnnounce(action, ctx);
  _onLoadMore(action, ctx);
  _onGetHotVideo(action, ctx);

  ///双击回到顶部
  bus.on(EventBusUtils.refreshCommunity, (arg) {
    ctx.state.pageNumber = 1;
    try {
      ctx.state.refreshController
          ?.requestRefresh(duration: Duration(milliseconds: 6));
    } catch (e) {
      l.d("双击回到顶部", "$e");
    }
  });

  bus.on(EventBusUtils.refreshRecommendFollowStatus, (arg) {
    ctx.state.commonPostRes?.list?.forEach((element) {
      if (element.publisher?.uid != null &&
          Config.followBlogger.containsKey(element.publisher?.uid)) {
        element.publisher.hasFollowed =
            Config.followBlogger[element.publisher.uid];
      }
    });

    ctx.dispatch(
        CommunityRecommendActionCreator.onGetData(ctx.state.commonPostRes));
  });
}

Future _onGetAnnounce(
    Action action, Context<CommunityRecommendState> ctx) async {
  try {
    AnnounceLiaoBaData specialModel = await netManager.client.getAnnounce();
    StringBuffer stringBuffer = new StringBuffer();
    specialModel.announcement.forEach((element) {
      stringBuffer.write(element.content + "               ");
    });
    ctx.dispatch(
        CommunityRecommendActionCreator.onGetAnnounce(stringBuffer.toString()));
  } catch (e) {
    l.e("getGroup", e);
  }
}

Future _onGetHotVideo(
    Action action, Context<CommunityRecommendState> ctx) async {
  try {
    String reqDate = await _getReqDate();
    //  CommonPostRes commonPostRes = await netManager.client.getCommunityRecommentListHotVideo(1, 9, ctx.state.id, reqDate,true);
    CommonPostRes commonPostRes =
        await netManager.client.communityHotlist(1, 9, "SP", reqDate);
    ctx.dispatch(CommunityRecommendActionCreator.onGetHotVideo(commonPostRes));
  } catch (e) {
    l.e("getGroup", e);
  }
}

void _onLoadMore(Action action, Context<CommunityRecommendState> ctx) async {
  int pageNumber;
  if (action.payload != null) {
    pageNumber = action.payload;
  } else {
    pageNumber = ctx.state.pageNumber;
  }

  int pageSize = ctx.state.pageSize;
  String reqDate = await _getReqDate();

  try {
    CommonPostRes commonPostRes = await netManager.client
        .getCommunityRecommentList(pageNumber, pageSize, ctx.state.id, reqDate);

    if (pageNumber > 1) {
      if (pageNumber % 10 == 0) {
        //PaintingBinding.instance.imageCache.clear();
        //PaintingBinding.instance.imageCache.clearLiveImages();
      }

      ctx.state.commonPostRes?.list?.addAll(commonPostRes?.list);
      int listCount = (ctx.state.commonPostRes?.list?.length ?? 0);

      ///添加换一换数据占位 26
      if (listCount > 25 &&
          ctx.state.commonPostRes?.list[25].newsType != NEWSTYPE_CHANGE_FUNC) {
        ctx.state.commonPostRes?.list
            ?.insert(25, await _buildChangeFuncUI(ctx, 25));
      }
      AdInsertManager.insertCommunityAd(ctx.state.commonPostRes?.list ?? []);
      ctx.dispatch(
          CommunityRecommendActionCreator.onGetData(ctx.state.commonPostRes));
    } else {
      //有多条置顶数据时，只取一条显示
      var topVms =
          commonPostRes.list.where((element) => element.isTopping).toList();
      var topVmsLength = topVms.length ?? 0;
      if (topVmsLength > 0) {
        commonPostRes.list.removeWhere((element) => topVms.contains(element));
        int index = Random().nextInt(topVmsLength);
        commonPostRes.list.insert(0, topVms.elementAt(index));
      }

      ///添加换一换数据占位 6
      if ((commonPostRes?.list?.length ?? 0) > 5 &&
          commonPostRes?.list[6].newsType != NEWSTYPE_CHANGE_FUNC) {
        commonPostRes?.list?.insert(6, await _buildChangeFuncUI(ctx, 6));
      }
      AdInsertManager.insertCommunityAd(commonPostRes?.list ?? []);

      ctx.dispatch(CommunityRecommendActionCreator.onGetData(commonPostRes));
    }

    ctx.state.refreshController.refreshCompleted();
    if (commonPostRes.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
  } catch (e) {
    l.d('getPostList', e.toString());
    ctx.state.refreshController.loadFailed();
  }
}

///创建推荐广告
Future<VideoModel> _buildRecommandAdCoverUI(
    Context<CommunityRecommendState> ctx) async {
  List<AdsInfoBean> adsList = ctx.state.recommendListAdsList;
  if ((adsList ?? []).length > 0) {
    AdsInfoBean adsInfoBean = adsList.removeAt(0);
    if (adsInfoBean != null) {
      adsList.add(adsInfoBean);
      ctx.dispatch(CommunityRecommendActionCreator.onRecommendListAds(adsList));

      VideoModel videoModel = VideoModel();
      videoModel.newsType = NEWSTYPE_AD_IMG;
      videoModel.id = adsInfoBean?.id;
      videoModel.cover = adsInfoBean?.cover;
      videoModel.linkUrl = adsInfoBean?.href;
      return Future.value(videoModel);
    }
  }
  return null;
}

///创建换一换UI
Future<VideoModel> _buildChangeFuncUI(
    Context<CommunityRecommendState> ctx, int index) async {
  await _changeDataListFunc(ctx, index);

  VideoModel videoModel = VideoModel();
  videoModel.newsType = NEWSTYPE_CHANGE_FUNC;
  videoModel.newsTypeIndex = index;
  return Future.value(videoModel);
}

///在第6、26位置新增换一换功能
void _reqChangeDataList(
    Action action, Context<CommunityRecommendState> ctx) async {
  int changeIndex = action.payload as int;
  if (changeIndex == 5 || changeIndex == 25) {
    await _changeDataListFunc(ctx, changeIndex);
  }
}

///新增换一换功能
Future _changeDataListFunc(
    Context<CommunityRecommendState> ctx, int changeIndex) async {
  try {
    List<GuessLikeDataList> dataList =
        await netManager.client.getRecommendChangeFuncList();
    l.d("获取换一换数据成功", "下标$changeIndex");
    if ((dataList ?? []).isNotEmpty) {
      ctx.dispatch(CommunityRecommendActionCreator.onChangeDataList(
          dataList, changeIndex));
    }
  } catch (e) {
    l.d("获取换一换数据异常", "$e");
  }
  return Future.value(true);
}

///检查是否有关注用户
void _checkFollowUser(
    Action action, Context<CommunityRecommendState> ctx) async {
  try {
    Map map = action.payload as Map;
    int uid = map["uid"];
    int changeDataIndex = map["changeDataIndex"];

    if (uid != null && Config.followBlogger.containsKey(uid)) {
      Config.followBlogger[uid] = true;
      ctx.dispatch(CommunityRecommendActionCreator.updateFollowState(
          uid, changeDataIndex));
    }
  } catch (e) {
    l.d("检查是否有关注用户数据异常", "$e");
  }
}
