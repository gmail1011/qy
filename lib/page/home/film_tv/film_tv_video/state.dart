import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/film_tv_video/AllSection.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FilmTelevisionVideoState extends GlobalBaseState implements Cloneable<FilmTelevisionVideoState> {
  BaseRequestController baseRequestController = BaseRequestController();
  RefreshController refreshController = RefreshController();
  bool isOnceSystemDialog = false;

  List<AdsInfoBean> adsList = [];
  List<AdsInfoBean> bannerAdsList = [];
  List<TagsDetailDataSections> list = List();
  List<LiaoBaTagsDetailDataVideos> videList =[];
  List<AllSection> allSection = [];
  int pageNumber = 1;
  int pageSize = 5;
  int moduleSort = 1;
  String videoName;
  String sectionID;
  int dataType = 0;
  String announcementContent;
  List<ProductBenefits> productBenefits = [];
  bool cutDownState = false;
  TabController tabController = TabController(length: Config.homeVideType.length, vsync: ScrollableState());

  LoadingWidget loadingWidget = LoadingWidget();



  @override
  FilmTelevisionVideoState clone() {
    return FilmTelevisionVideoState()
      ..baseRequestController = baseRequestController
      ..refreshController = refreshController
      ..announcementContent = announcementContent
      ..productBenefits = productBenefits
      ..cutDownState = cutDownState
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..videoName = videoName
      ..sectionID = sectionID
      ..adsList = adsList
      ..bannerAdsList = bannerAdsList
      ..videList = videList
      ..allSection = allSection
      ..moduleSort = moduleSort
      ..isOnceSystemDialog = isOnceSystemDialog
      ..dataType = dataType

      ..loadingWidget = loadingWidget

      ..list = list;
  }
}

FilmTelevisionVideoState initState(Map<String, dynamic> args) {
  return FilmTelevisionVideoState()
    ..videoName = args["videoName"]
    ..sectionID = args["sectionID"]
    ..dataType = args["dataType"]
    ..cutDownState = false;
}
