import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/search/search_home_model.dart';
import 'package:flutter_app/model/search/search_topic_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/search/search_tag/search_tag_item/state.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HotListState with EagleHelper implements Cloneable<HotListState> {
  int pageNumber = 1;
  int pageSize = 15;
  String theme = "";
  ToneListBean bean;
  SearchTopicModel topModel;
  List<VideoModel> videoList = [];
  EasyRefreshController controller = EasyRefreshController();
  ScrollController scrollController = ScrollController();

  // 连接通知器
  LinkHeaderNotifier headerNotifier = LinkHeaderNotifier();

  List<SearchTagItemState> items;

  RefreshController headerRefreshController =
      RefreshController(initialRefresh: false);

  bool requestComplete = false;

  bool isShowLoading = false;

  @override
  HotListState clone() {
    return HotListState()
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..bean = bean
      ..topModel = topModel
      ..videoList = videoList
      ..theme = theme
      ..controller = controller
      ..scrollController = scrollController
      ..headerNotifier = headerNotifier
      ..items = items
      ..requestComplete = requestComplete
      ..isShowLoading = isShowLoading;
  }
}

HotListState initState(Map<String, dynamic> args) {
  return HotListState()
    ..theme = args['theme']
    ..bean = args['searchBean'];
}
