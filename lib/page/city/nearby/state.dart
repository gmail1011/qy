import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class NearbyState extends GlobalBaseState with EagleHelper implements Cloneable<NearbyState> {
  ScrollController scrollController = new ScrollController();

  List<VideoModel> videoList = List();

  String city;

  int pageNumber = 0;
  int pageSize = 20;

  bool serverIsNormal = true;

  String errorMsg = "";

  EasyRefreshController controller = EasyRefreshController();

  bool requestSuccess = false;

  bool showToTopBtn = false;

  bool hasNext;

  bool isLoading;

  NearbyState() {
    String currentCity = GlobalStore.store?.getState()?.meInfo?.city;
    if (TextUtil.isEmpty(currentCity)) {
      currentCity = "北京";
    }
    city = currentCity;
  }

  @override
  NearbyState clone() {
    NearbyState nearbyState = NearbyState();
    nearbyState.videoList = videoList;
    nearbyState.city = city;
    nearbyState.isLoading = isLoading;
    nearbyState.hasNext = hasNext;
    nearbyState.pageNumber = pageNumber;
    nearbyState.serverIsNormal = serverIsNormal;
    nearbyState.errorMsg = errorMsg;
    nearbyState.controller = controller;
    nearbyState.pageSize = pageSize;
    nearbyState.requestSuccess = requestSuccess;
    nearbyState.showToTopBtn = showToTopBtn;
    return nearbyState;
  }
}

NearbyState initState(Map<String, dynamic> args) {
  NearbyState nearbyState = NearbyState();
  nearbyState.pageNumber = 1;
  return nearbyState;
}
