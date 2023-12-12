import 'package:connectivity/connectivity.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/model/nearby_bean.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import '../../../common/net2/net_manager.dart';
import 'action.dart';
import 'state.dart';

Effect<NearbyState> buildEffect() {
  return combineEffects(<Object, Effect<NearbyState>>{
    Lifecycle.initState: _onInitData,
    NearbyAction.selectCity: _onSelectCity,
    NearbyAction.loadMore: _onLoadMoreData,
    NearbyAction.onItemClick: _onItemClick,
    NearbyAction.onRefresh: _onRefresh,
    NearbyAction.onRefreshFollowStatus: _onRefreshFollowStatus,
  });
}

///获取数据
_onInitData(Action action, Context<NearbyState> ctx) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    //滚动超过一屏幕的尺寸
    var result = await new Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      ctx.dispatch(NearbyActionCreator.onError(Lang.NETWORK_ERROR));
      return;
    }
    ctx.state.pageNumber = await lightKV.getInt(Config.NEAR_BY_PAGE_NUMBER);
    await _getNearbyData(ctx, true);
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

///获取数据
_onLoadMoreData(Action action, Context<NearbyState> ctx) async {
  await _getNearbyData(ctx, false);
}

///下拉刷新
_onRefresh(Action action, Context<NearbyState> ctx) async {
  ctx.state.pageNumber = await lightKV.getInt(Config.NEAR_BY_PAGE_NUMBER);
  await _getNearbyData(ctx, true);
}

///点击视频
Future<void> _onItemClick(Action action, Context<NearbyState> ctx) async {
  Map<String, dynamic> param = {};
  param["city"] = ctx.state.city;
  param["pageSize"] = ctx.state.pageSize;
  param["pageNumber"] = ctx.state.pageNumber;
  param["currentPosition"] = action.payload;
  param["playType"] = VideoPlayConfig.VIDEO_TYPE_NEARBY;
  param["apiAddress"] = Address.SAME_CITY_LIST;
  param["videoList"] = ctx.state.videoList;
  JRouter().go(SUB_PLAY_LIST, arguments: param);
}

///选择城市
_onSelectCity(Action action, Context<NearbyState> ctx) async {
  var res = await JRouter().go(PAGE_CITY_SELECT);
  String cityAndProvince = res as String;
  if (cityAndProvince == null) {
    return;
  }
  List<String> str = cityAndProvince.split("_");
  var newCity = str[0].replaceAll("市", "");

  ctx.dispatch(NearbyActionCreator.selectCitySuccess(newCity));
  ctx.state.pageNumber = 0;
  _getNearbyData(ctx, true);
}

///获取附近数据
Future _getNearbyData(Context<NearbyState> ctx, bool isRefresh) async {
  var result = await new Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    ctx.dispatch(NearbyActionCreator.onError(Lang.NETWORK_ERROR));
    showToast(msg: Lang.NETWORK_ERROR);
    return;
  }
  if (ctx.state.isLoading ?? false) {
    return;
  }
  ctx.state.isLoading = true;
  int pageNumber = ctx.state.pageNumber + 1;
  int pageSize = ctx.state.pageSize;
  String city = ctx.state.city;
  // Map<String, dynamic> mapList = Map();
  // mapList['pageNumber'] = ctx.state.pageNumber + 1;
  // mapList['pageSize'] = ctx.state.pageSize;
  // mapList['city'] = ctx.state.city;
  try {
    NearbyBean nearbyBean =
        await netManager.client.getCityVideoList(pageNumber, pageSize, city,"SP");
    ctx.state.isLoading = false;
    if (isRefresh) {
      ctx.state.videoList = [];
      ctx.state.controller.finishRefresh(success: true);
    } else {
      ctx.state.controller.finishLoad(success: true);
    }
    ++ctx.state.pageNumber;
    if (nearbyBean.hasNext) {
      lightKV.setInt(Config.NEAR_BY_PAGE_NUMBER, ctx.state.pageNumber);
    } else {
      lightKV.setInt(Config.NEAR_BY_PAGE_NUMBER, 0);
      if (ctx.state.pageNumber != 1) {
        ctx.state.pageNumber = 0;
        _getNearbyData(ctx, false);
      }
    }
    ctx.state.hasNext = nearbyBean.hasNext;
    ctx.state.serverIsNormal = true;
    ctx.state.videoList.addAll(nearbyBean.vInfo);
    ctx.state.requestSuccess = true;
    if (ctx.state.videoList.length == 0) {
      ctx.state.errorMsg = Lang.NO_DATA;
      ctx.state.serverIsNormal = false;
    }
    ctx.dispatch(NearbyActionCreator.requestDataSuccess());
  } catch (e) {
    l.d('getCityVideoList=', e.toString());
    ctx.dispatch(NearbyActionCreator.onError(e.toString() ?? ''));
    //showToast(msg: e.toString());
  }
  // BaseResponse res = await getCityVideoList(mapList);
  // ctx.state.isLoading = false;
  // if (isRefresh) {
  //   ctx.state.videoList = [];
  //   ctx.state.controller.finishRefresh(success: true);
  // } else {
  //   ctx.state.controller.finishLoad(success: true);
  // }
  // if (res.code == 200) {
  //   NearbyBean nearbyBean = NearbyBean.fromMap(res.data);
  //   ++ctx.state.pageNumber;
  //   if (nearbyBean.hasNext) {
  //     lightKV.setInt(Config.NEAR_BY_PAGE_NUMBER, ctx.state.pageNumber);
  //   } else {
  //     lightKV.setInt(Config.NEAR_BY_PAGE_NUMBER, 0);
  //     if (ctx.state.pageNumber != 1) {
  //       ctx.state.pageNumber = 0;
  //       _getNearbyData(ctx, false);
  //     }
  //   }
  //   ctx.state.hasNext = nearbyBean.hasNext;
  //   ctx.state.serverIsNormal = true;
  //   ctx.state.videoList.addAll(nearbyBean.vInfo);
  //   ctx.state.requestSuccess = true;
  //   if (ctx.state.videoList.length == 0) {
  //     ctx.state.errorMsg = Lang.NO_DATA;
  //     ctx.state.serverIsNormal = false;
  //   }
  //   ctx.dispatch(NearbyActionCreator.requestDataSuccess());
  // } else {
  //   ctx.dispatch(NearbyActionCreator.onError(res.msg ?? ''));
  //   showToast(msg: res.msg);
  // }
}

///更新附近-视频发布人的关注信息
Future _onRefreshFollowStatus(Action action, Context<NearbyState> ctx) async {
  Map<String, dynamic> map = action.payload;
  int uid = map['uid'];
  for (var value in ctx.state.videoList) {
    if (value.publisher.uid == uid &&
        value.publisher.hasFollowed != map['isFollow']) {
      value.publisher.hasFollowed = map['isFollow'];
    }
  }
}
