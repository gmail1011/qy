import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/city_detail_model.dart';
import 'package:flutter_app/model/nearby_bean.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CityVideoState extends MutableSource
    with EagleHelper implements Cloneable<CityVideoState> {
  CityDetailModel cityDetailModel;
  String id;
  String city;
  bool serverIsNormal = true;
  int pageNumber = 1;
  int pageCoverNumber = 1;
  int pageLongMovieNumber = 1;
  var keys = {};
  int pageSize = 20;
  EasyRefreshController controller = EasyRefreshController();

  ScrollController scrollController = new ScrollController();

  // 连接通知器
  LinkHeaderNotifier headerNotifier = LinkHeaderNotifier();

  int lastPosition = 0;

  bool hasNext = true;

  List<PostItemState> items = [];

  TabController tabController = new TabController(length: 3, vsync: ScrollableState());


  NearbyBean nearbyBean;
  NearbyBean nearbyLongBean;
  NearbyBean nearbyCoverBean;

  RefreshController refreshController = new RefreshController();

  RefreshController refreshCoverController = new RefreshController();
  RefreshController refreshLongMovieController = new RefreshController();

  @override
  CityVideoState clone() {
    CityVideoState cityVideoState = CityVideoState();
    cityVideoState.cityDetailModel = cityDetailModel;
    cityVideoState.id = id;
    cityVideoState.city = city;
    cityVideoState.serverIsNormal = serverIsNormal;
    cityVideoState.controller = controller;
    cityVideoState.scrollController = scrollController;
    cityVideoState.pageNumber = pageNumber;
    cityVideoState.pageCoverNumber = pageCoverNumber;
    cityVideoState.keys = keys;
    cityVideoState.lastPosition = lastPosition;
    cityVideoState.hasNext = hasNext;
    cityVideoState.items = items;
    cityVideoState.pageSize = pageSize;
    cityVideoState.tabController = tabController;
    cityVideoState.nearbyBean = nearbyBean;
    cityVideoState.nearbyLongBean = nearbyLongBean;
    cityVideoState.refreshController = refreshController;

    cityVideoState.nearbyCoverBean = nearbyCoverBean;
    cityVideoState.refreshCoverController = refreshCoverController;
    return cityVideoState;
  }

  @override
  Object getItemData(int index) {
    return items[index];
  }

  @override
  String getItemType(int index) {
    return 'cityItem';
  }

  @override
  int get itemCount => items.length;

  @override
  void setItemData(int index, Object data) {
    items[index] = data;
  }
}

CityVideoState initState(Map<String, dynamic> args) {
  CityVideoState cityVideoState = CityVideoState();
  Map<String, dynamic> map = args;
  cityVideoState.city = map['city'];
  cityVideoState.id = map['id'];
  cityVideoState.controller.finishLoad(success: true, noMore: true);
  cityVideoState.keys = Map();
  return cityVideoState;
}
