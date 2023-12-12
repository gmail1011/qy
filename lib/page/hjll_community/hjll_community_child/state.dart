import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/film_tv_video/AllSection.dart';
import 'package:flutter_app/model/film_tv_video/AllTags.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HjllCommunityChildState extends GlobalBaseState implements Cloneable<HjllCommunityChildState> {
  BaseRequestController baseRequestController = BaseRequestController();
  RefreshController refreshController = RefreshController();

  List<AdsInfoBean> adsList = [];
  List<TagsDetailDataSections> list = List();
  List<LiaoBaTagsDetailDataVideos> videList =[];
  List<AllTags> allTags;
  int pageNumber = 1;
  int pageSize = 5;
  int moduleSort = 3;//默认推荐     //1、最新，2、最热，3、最多播放量或者推荐，4、十分钟以上视频，5、精华，6、视频
  String videoName;
  String sectionID;
  String announcementContent;
  List<ProductBenefits> productBenefits = [];
  bool cutDownState = false;
  TabController tabController = TabController(length: Config.communityVideType.length, vsync: ScrollableState());

  @override
  HjllCommunityChildState clone() {
    return HjllCommunityChildState()
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
      ..videList = videList
      ..allTags = allTags
      ..tabController = tabController
      ..moduleSort = moduleSort
      ..list = list;
  }
}

HjllCommunityChildState initState(Map<String, dynamic> args) {
  return HjllCommunityChildState()
    ..videoName = args["videoName"]
    ..sectionID = args["sectionID"]
    ..cutDownState = false;
}
