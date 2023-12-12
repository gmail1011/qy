import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/city_detail_model.dart';
import 'package:flutter_app/model/nearby_bean.dart';
import 'package:flutter_app/page/home/post/post_item_component/action.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';

Effect<CityVideoState> buildEffect() {
  return combineEffects(<Object, Effect<CityVideoState>>{
    Lifecycle.initState: _onInitData,
    CityVideoAction.onInitData: getVideoList,
    CityVideoAction.onGetData: _onInitData,
    PostItemAction.tellFatherJumpPage: _onJumpToVideoPlayList,
    Lifecycle.dispose: _onDispose,
    CityVideoAction.onMovieLoadMore: getVideoList,
    CityVideoAction.onCoverLoadMore: getCoverList,
    CityVideoAction.onLongMovieLoadMore: getLongList,
  });
}

void _onJumpToVideoPlayList(Action action, Context<CityVideoState> ctx) {
  l.i("post", "_onJumpToVideoPlayList()...city");
  PostItemState itemState = action.payload;
  Map<String, dynamic> map = Map();
  map['playType'] = VideoPlayConfig.VIDEO_POST;
  map['pageNumber'] = ctx.state.pageNumber;
  // map['uid'] = ctx.state.uid;
  map['pageSize'] = ctx.state.pageSize;
  // map["apiAddress"] = Address.MINE_WORKS;
  map['currentPosition'] =
      ctx.state.items.indexWhere((it) => it.uniqueId == itemState.uniqueId);
  map['videoList'] = ctx.state.items.map((it) => it.videoModel).toList();
  JRouter().go(SUB_PLAY_LIST, arguments: map);
}

Future _onInitData(Action action, Context<CityVideoState> ctx) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    await getCityDetail(ctx);
    //获取列表
    getVideoList(action, ctx);
    Future.delayed(Duration(milliseconds: 400),(){
      getCoverList(action, ctx);
     // getLongList(action, ctx);
    });
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

///获取城市详情
Future getCityDetail(Context<CityVideoState> ctx) async {
  CityDetailModel cityDetailModel;
  try {
    cityDetailModel = await netManager.client.getCityDetail(ctx.state.id);
  } catch (e) {
    l.d('getCityDetail===', e.toString());
  }
  if (cityDetailModel != null) {
    ctx.dispatch(CityVideoActionCreator.onCityDetail(cityDetailModel));
  } else {
    ctx.dispatch(CityVideoActionCreator.onError(""));
  }
}

///获取城市视频列表
Future getVideoList(Action action, Context<CityVideoState> ctx) async {
  NearbyBean nearbyBean;
  try {
    if (action.payload != null) {
      nearbyBean = await netManager.client.getCityVideoList(
          action.payload, ctx.state.pageSize, ctx.state.city, "SP");

      ctx.state.nearbyBean.vInfo.addAll(nearbyBean.vInfo);

      if (nearbyBean.hasNext) {
        ctx.state.refreshController.loadComplete();
      } else {
        ctx.state.refreshController.loadNoData();
      }

      ctx.dispatch(
          CityVideoActionCreator.onGetCityVideoList(ctx.state.nearbyBean));
    } else {
      nearbyBean = await netManager.client.getCityVideoList(
          ctx.state.pageNumber, ctx.state.pageSize, ctx.state.city, "SP");

      if (nearbyBean.hasNext) {
        ctx.state.refreshController.loadComplete();
      } else {
        ctx.state.refreshController.loadNoData();
      }

      ctx.dispatch(CityVideoActionCreator.onGetCityVideoList(nearbyBean));
    }
  } catch (e) {
    l.d('getCityVideoList=', e.toString());
    //showToast(msg: e.toString());
    ctx.dispatch(CityVideoActionCreator.onError(e.toString()));
  }
}

///获取城市长视频列表
Future getLongList(Action action, Context<CityVideoState> ctx) async {
  NearbyBean nearbyBean;
  try {
    if (action.payload != null) {
      nearbyBean = await netManager.client.getCityVideoList(
          action.payload, ctx.state.pageSize, ctx.state.city, "MOVIE");

      nearbyBean.vInfo.removeWhere((element) => element.newsType == "SP");
      nearbyBean.vInfo.removeWhere((element) => element.newsType == "COVER");
      ctx.state.nearbyLongBean.vInfo.addAll(nearbyBean.vInfo);

      if (nearbyBean.hasNext) {
        ctx.state.refreshLongMovieController.loadComplete();
      } else {
        ctx.state.refreshLongMovieController.loadNoData();
      }

      ctx.dispatch(
          CityVideoActionCreator.onGetCityCoverList(ctx.state.nearbyCoverBean));
    } else {
      nearbyBean = await netManager.client.getCityVideoList(
          ctx.state.pageLongMovieNumber, ctx.state.pageSize, ctx.state.city, "MOVIE");

      nearbyBean.vInfo.removeWhere((element) => element.newsType == "SP");
      nearbyBean.vInfo.removeWhere((element) => element.newsType == "COVER")
      ;
      if (nearbyBean.hasNext) {
        ctx.state.refreshLongMovieController.loadComplete();
      } else {
        ctx.state.refreshLongMovieController.loadNoData();
      }

      ctx.dispatch(CityVideoActionCreator.onGetCityCoverList(nearbyBean));
    }
  } catch (e) {
    l.d('getCityVideoList=', e.toString());
    //showToast(msg: e.toString());
    ctx.dispatch(CityVideoActionCreator.onError(e.toString()));
  }
}


///获取城市视频列表
Future getCoverList(Action action, Context<CityVideoState> ctx) async {
  NearbyBean nearbyBean;
  try {
    if (action.payload != null) {
      nearbyBean = await netManager.client.getCityVideoList(
          action.payload, ctx.state.pageSize, ctx.state.city, "COVER");

      nearbyBean.vInfo.removeWhere((element) => element.newsType == "SP");

      ctx.state.nearbyCoverBean.vInfo.addAll(nearbyBean.vInfo);

      if (nearbyBean.hasNext) {
        ctx.state.refreshCoverController.loadComplete();
      } else {
        ctx.state.refreshCoverController.loadNoData();
      }

      ctx.dispatch(
          CityVideoActionCreator.onGetCityCoverList(ctx.state.nearbyCoverBean));
    } else {
      nearbyBean = await netManager.client.getCityVideoList(
          ctx.state.pageCoverNumber, ctx.state.pageSize, ctx.state.city, "COVER");

      nearbyBean.vInfo.removeWhere((element) => element.newsType == "SP");

      if (nearbyBean.hasNext) {
        ctx.state.refreshCoverController.loadComplete();
      } else {
        ctx.state.refreshCoverController.loadNoData();
      }

      ctx.dispatch(CityVideoActionCreator.onGetCityCoverList(nearbyBean));
    }
  } catch (e) {
    l.d('getCityVideoList=', e.toString());
    //showToast(msg: e.toString());
    ctx.dispatch(CityVideoActionCreator.onError(e.toString()));
  }
}

///页面销毁
_onDispose(Action action, Context<CityVideoState> ctx) {
  ctx.state.scrollController.dispose();
  ctx.state.controller.dispose();
  ctx.state.headerNotifier.dispose();
}
