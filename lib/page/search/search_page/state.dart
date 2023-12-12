import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/search_default_entity.dart';
import 'package:flutter_app/model/search_default_hot_blogger_entity.dart';
import 'package:flutter_app/model/tag/hot_tag_model.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';

class SearchState with EagleHelper implements Cloneable<SearchState> {
  var inputText = '';
  var showAll = false;
  List<String> searchHistorys;
  TextEditingController textEditingController = TextEditingController();
  List<TagDetailModel> tagList = <TagDetailModel>[];
  BaseRequestController baseRequestController = BaseRequestController();
  int showSearchHistoryNum = 2; //没有展开时显示的搜索条数
  int maxSearchHistoryNum = 6; //最多记录历史记录调数

  List<HotTagItem> hotList = [];
  List<AdsInfoBean> adsList = [];
  SearchDefaultData searchDefaultData;

  TabController tabController = new TabController(length: 2, vsync: ScrollableState());

  SearchDefaultHotBloggerData searchDefaultHotBloggerData;

  @override
  SearchState clone() {
    return SearchState()
      ..inputText = inputText
      ..searchHistorys = searchHistorys
      ..textEditingController = textEditingController
      ..baseRequestController = baseRequestController
      ..tagList = tagList
      ..tabController = tabController
      ..searchDefaultData = searchDefaultData
      ..searchDefaultHotBloggerData = searchDefaultHotBloggerData
      ..hotList = hotList
      ..adsList = adsList
      ..showAll = showAll;
  }
}

SearchState initState(Map<String, dynamic> args) {
  return SearchState();
}
