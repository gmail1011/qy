import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'SelectedBean.dart';

class common_post_detailState implements Cloneable<common_post_detailState> {

  String id;
  String title;

  int pageNumber = 1;
  int pageSize = 20;

  LiaoBaTagsDetailData liaoBaHistoryData;

  RefreshController refreshController = RefreshController();
  BaseRequestController baseRequestController = BaseRequestController();


  String selectedType = "全部类型";
  List<String> typeOptions = [
    '全部类型',
    '长视频',
    '短视频',
  ];


  String selectedSort  = "热门推荐";
  List<String> sortOptions = [
    '热门推荐',
    '最多播放',
    '收藏最多',
    "最新上架"
  ];

  SelectedBean selectedBean = new SelectedBean();

  ScrollController scrollController = new ScrollController();

  @override
  common_post_detailState clone() {
    return common_post_detailState()
      ..id = id
      ..title = title
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..liaoBaHistoryData = liaoBaHistoryData
      ..refreshController = refreshController
      ..baseRequestController = baseRequestController

      ..selectedType = selectedType
      ..typeOptions = typeOptions

      ..selectedSort = selectedSort
      ..sortOptions = sortOptions

      ..selectedBean = selectedBean

      ..scrollController = scrollController
    ;
  }
}

common_post_detailState initState(Map<String, dynamic> args) {
  return common_post_detailState()..id = args["id"]..title = args["title"];
}
