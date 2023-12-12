import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/countdown_update_model.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/announce_liao_ba_entity.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/film_tv_video/TagsVideoDataModel.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/tabs_tag_entity.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:provider/provider.dart';

import 'action.dart';
import 'state.dart';

Effect<HjllCommunityChildState> buildEffect() {
  return combineEffects(<Object, Effect<HjllCommunityChildState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    HjllCommunityChildAction.loadData: _onLoadData,
    HjllCommunityChildAction.loadMoreData: _onLoadMoreData,
  });
}

void _initState(Action action, Context<HjllCommunityChildState> ctx) async {
  String videoName = ctx.state.videoName;
  l.d("videoName", "$videoName");
  _getCutDown(ctx);
  _getAdList(ctx);
  // _announceReq(ctx);

  ctx.dispatch(FilmTelevisionVideoActionCreator.checkProductBenefits());

  _onLoadData(action, ctx);
  // ctx.state.tabController.addListener(() {
  //   int index = ctx.state.tabController.index;
  //   ctx.state.moduleSort = index+1;
  //   _onLoadData(action, ctx);
  // });


  ctx.state.tabController.addListener(clearAllCache);
}

///获取广告列表
void _getAdList(Context<HjllCommunityChildState> ctx) async {
  List<AdsInfoBean> list = await getAdvByType(4);
  ctx.dispatch(FilmTelevisionVideoActionCreator.getAdSuccess(list));
}

/// 获取会员卡倒计时
void _getCutDown(Context<HjllCommunityChildState> ctx) async {
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
void _announceReq(Context<HjllCommunityChildState> ctx) async {
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
String _queryVideoIdByVideoName(String videoName) {
  for (TabsTagData data in (Config.communityDataTags ?? [])) {
    if (data?.moduleName == videoName) {
      return data.id;
    }
  }
  return Config.communityDataTags[0]?.id;
}

///初始化数据
Future _onLoadData(Action action, Context<HjllCommunityChildState> ctx) async {
  try {
    // List<TagsDetailDataSections> specialModelList = [];
    List<LiaoBaTagsDetailDataVideos>  videoList = [];
    TagsVideoDataModel tagsVideoDataModel = await netManager.client.getTagsDetails(ctx.state.sectionID, ctx.state.pageSize, 1,ctx.state.moduleSort);
    if(tagsVideoDataModel!=null){
      videoList = tagsVideoDataModel.allVideoInfo;
    }
    ctx.dispatch(FilmTelevisionVideoActionCreator.setLoadVideoData(videoList));
    if(tagsVideoDataModel.allSection !=null && tagsVideoDataModel.allSection.length>0){
      ctx.dispatch(FilmTelevisionVideoActionCreator.setTagsData(tagsVideoDataModel.allSection[0].allTags));
    }
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    // if ((videoList?.length ?? 0) == 0) {
    //   ctx.state.baseRequestController.requestDataEmpty();
    // } else {
    //   ctx.state.baseRequestController.requestSuccess();
    // }
    ctx.state.baseRequestController.requestSuccess();
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
    ctx.state.baseRequestController.requestFail();
    l.d("_onLoadData", e);
  }
}

///初始化数据
Future _onLoadMoreData(
    Action action, Context<HjllCommunityChildState> ctx) async {
  try {
    String _videoId = _queryVideoIdByVideoName(ctx.state.videoName);
    var number = ctx.state.pageNumber + 1;
    List<TagsDetailDataSections> specialModelList = await netManager.client
        .getTagsDetails(_videoId, ctx.state.pageSize, number,ctx.state.moduleSort);

    ctx.dispatch(
        FilmTelevisionVideoActionCreator.setLoadMoreData(specialModelList));
    if (specialModelList.length > 0) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
  } catch (e) {
    ctx.state.refreshController.loadFailed();
  }
}

void _dispose(Action action, Context<HjllCommunityChildState> ctx) {
  clearAllCache();
  ctx.state.tabController.removeListener(clearAllCache);
  ctx.state.tabController?.dispose();
  ctx.state.refreshController?.dispose();
}
