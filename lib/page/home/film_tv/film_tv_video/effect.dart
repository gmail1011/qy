import 'dart:convert';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/countdown_update_model.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/announce_liao_ba_entity.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/film_tv_video/TagsVideoDataModel.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/tabs_tag_entity.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart';
import 'package:flutter_app/widget/dialog/newdialog/system_image_dialog.dart';
import 'package:flutter_app/widget/dialog/newdialog/system_word_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:provider/provider.dart';

import 'action.dart';
import 'state.dart';

Effect<FilmTelevisionVideoState> buildEffect() {
  return combineEffects(<Object, Effect<FilmTelevisionVideoState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    FilmTelevisionVideoAction.loadData: _onLoadData,
    FilmTelevisionVideoAction.loadMoreData: _onLoadMoreData,
  });
}

void _initState(Action action, Context<FilmTelevisionVideoState> ctx) async {
  String videoName = ctx.state.videoName;
  l.d("videoName", "$videoName");
  _getCutDown(ctx);
  _getAdList(ctx);
  // _announceReq(ctx);

  ctx.dispatch(FilmTelevisionVideoActionCreator.checkProductBenefits());

  _onLoadData(action, ctx);
  ctx.state.tabController.addListener(() {
    int index = ctx.state.tabController.index;
    ctx.state.moduleSort = index + 1;
    _onLoadData(action, ctx);

    clearAllCache();
  });
}

_showImageDialog(Action action, Context<FilmTelevisionVideoState> ctx) async {
  List<AdsInfoBean> adsInfoList = await getAdvByType(2);
  if (adsInfoList.isEmpty) {
    return;
  }
  AdsInfoBean adsInfoBean = adsInfoList[0];
  return showDialog(
      context: ctx.context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SystemImageDialog(
          cover: adsInfoBean.cover,
        );
      });
}

///显示公告信息
_showWordDialog(Action action, Context<FilmTelevisionVideoState> ctx) async {
  ///若已显示则不再弹出
  if (ctx.state.isOnceSystemDialog) return;
  String aInfo = await lightKV.getString(Config.ANNOUNCEMENT_INFO);
  if (aInfo == null || aInfo.isEmpty) {
    return;
  }
  List<dynamic> tempList = jsonDecode(aInfo);
  int totalIndex = -1;

  for (int i = 0; i < tempList.length; i++) {
    totalIndex = i;
    AnnounceInfoBean wordBean = AnnounceInfoBean.fromJson(tempList[i]);

    if (wordBean.type == 0) {
      await showDialog(
          context: ctx.context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return SystemWordDialog(
              content: wordBean.content,
              // addr: Config.SOURCE_URL + "/" + wordBean.cover,
            );
          }).then((value) async {
        if (value != null &&
            value is bool &&
            value &&
            wordBean != null &&
            wordBean.href != "") {
          await JRouter().handleAdsInfo(wordBean.href);
        }
      });
    } else if (wordBean.type == 1) {
    } else if (wordBean.type == 2 || wordBean.type == 3) {
      Config.announceInfoBeanList.add(wordBean);
    }
  }
}

///获取广告列表
void _getAdList(Context<FilmTelevisionVideoState> ctx) async {
  List<AdsInfoBean> list = await getAdvByType(8);
  List<AdsInfoBean> bannerList = await getAdvByType(3);
  ctx.state.bannerAdsList = bannerList;
  ctx.dispatch(FilmTelevisionVideoActionCreator.getAdSuccess(list));
}

/// 获取会员卡倒计时
void _getCutDown(Context<FilmTelevisionVideoState> ctx) async {
  try {
    Countdown countdown = await netManager.client.getCutDown();
    Provider.of<CountdwonUpdate>(ctx.context, listen: false)
        .setCountdown(countdown);
    if ((countdown?.countdownSec ?? 0) > 0) {
      ctx.dispatch(FilmTelevisionVideoActionCreator.checkVipCutDownState(true));
    } else {
      ctx.dispatch(
          FilmTelevisionVideoActionCreator.checkVipCutDownState(false));
    }
  } catch (e) {
    l.d('getCutDown==', e.toString());
  }
}

///请求公告
void _announceReq(Context<FilmTelevisionVideoState> ctx) async {
  try {
    AnnounceLiaoBaData specialModel = await netManager.client.getAnnounce();
    bool hasannouncementData = false;
    String announcementContent = "";
    specialModel?.announcement?.forEach((element) {
      if ((element.position == 2) ?? false) {
        hasannouncementData = true;
        announcementContent += (element.content + "               ");
        ctx.dispatch(FilmTelevisionVideoActionCreator.setAnnouncementContent(
            announcementContent));
      }
    });

    //  ctx.state.announcementContent
    if (!hasannouncementData) {
      l.d("scrollController-offset", "没有公告数据");
      return;
    }
  } catch (e) {
    l.d("请求公告错误", "$e");
  }
}

///通过videoName 查询videoID
String _queryVideoIdByVideoName(String videoName, int pageType) {
  List<TabsTagData> temp = [];
  if (pageType == 0) {
    temp = Config.homeDataTags;
  } else {
    temp = Config.deepWeb;
  }
  for (TabsTagData data in (temp ?? [])) {
    if (data?.moduleName == videoName) {
      return data.id;
    }
  }
  return temp[0]?.id;
}

///初始化数据
Future _onLoadData(Action action, Context<FilmTelevisionVideoState> ctx) async {
  try {

    String _videoId =
        _queryVideoIdByVideoName(ctx.state.videoName, ctx.state.dataType);
    // List<TagsDetailDataSections> specialModelList = [];
    List<LiaoBaTagsDetailDataVideos> videoList = [];
    TagsVideoDataModel tagsVideoDataModel = await netManager.client
        .getTagsDetails(
            _videoId, ctx.state.pageSize, 1, action.payload ?? 1);
    if (tagsVideoDataModel != null) {
      videoList = tagsVideoDataModel.allVideoInfo;
    }
    ctx.dispatch(FilmTelevisionVideoActionCreator.setLoadVideoData(videoList));
    ctx.dispatch(FilmTelevisionVideoActionCreator.setTagsData(
        tagsVideoDataModel.allSection));
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    // if ((videoList?.length ?? 0) == 0) {
    //   ctx.state.baseRequestController.requestDataEmpty();
    // } else {
    //   ctx.state.baseRequestController.requestSuccess();
    // }
    ctx.state.baseRequestController.requestSuccess();

    ctx.state.loadingWidget.cancel();
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
    ctx.state.baseRequestController.requestFail();
    l.d("_onLoadData", e);
  }
}

///初始化数据
Future _onLoadMoreData(
    Action action, Context<FilmTelevisionVideoState> ctx) async {
  try {
    String _videoId =
        _queryVideoIdByVideoName(ctx.state.videoName, ctx.state.dataType);
    var number = ctx.state.pageNumber + 1;
    List<LiaoBaTagsDetailDataVideos> videoList = [];
    TagsVideoDataModel tagsVideoDataModel = await netManager.client
        .getTagsDetails(
            _videoId, ctx.state.pageSize, number, action.payload ?? 1);
    if (tagsVideoDataModel != null) {
      videoList = tagsVideoDataModel.allVideoInfo;
    }

    if (number % 14 == 0) {
      clearAllCache();
    }

    ctx.dispatch(FilmTelevisionVideoActionCreator.setLoadMoreData(videoList));
    if (!tagsVideoDataModel.hasNext) {
      ctx.state.refreshController.loadNoData();
    } else {
      ctx.state.refreshController.loadComplete();
    }
  } catch (e) {
    ctx.state.refreshController.loadFailed();
  }
}

void _dispose(Action action, Context<FilmTelevisionVideoState> ctx) {
  ctx.state.refreshController?.dispose();
}
