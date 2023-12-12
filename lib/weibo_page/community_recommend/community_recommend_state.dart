import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/res/common_post_res.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'search/guess_like_entity.dart';

class CommunityRecommendState implements Cloneable<CommunityRecommendState> {
  List<AdsInfoBean> adsList = [];
  List<AdsInfoBean> recommendListAdsList = [];
  Map<int, List<GuessLikeDataList>> changeDataListMap = {};

  String announce;
  int pageNumber = 1;
  int pageSize = 10;

  RefreshController refreshController = RefreshController();
  CommonPostRes commonPostRes;
  String id;
  String name;

  CommonPostRes commonPostResHotVideo;
  ScrollController scrollController = ScrollController();
  bool isScrolling = false;
  int visiblePosition = -1;

  double  listMaxHeight =  screen.screenHeight - (kBottomNavigationBarHeight + screen.paddingBottom) - 44;
  @override
  CommunityRecommendState clone() {
    return CommunityRecommendState()
      ..adsList = adsList
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..refreshController = refreshController
      ..commonPostRes = commonPostRes
      ..commonPostResHotVideo = commonPostResHotVideo
      ..announce = announce
      ..name = name
      ..recommendListAdsList = recommendListAdsList
      ..changeDataListMap = changeDataListMap
      ..scrollController = scrollController
      ..visiblePosition = visiblePosition
      ..isScrolling = isScrolling
      ..id = id;
  }
}

CommunityRecommendState initState(Map<String, dynamic> args) {
  return CommunityRecommendState()..id = (args == null ? null : args["id"])..name = (args == null ? null : args["name"]);
}
