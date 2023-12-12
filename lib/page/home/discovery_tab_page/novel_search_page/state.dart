import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/model/novel_model.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';

class NovelSearchState implements Cloneable<NovelSearchState> {
  var inputText = '';
  var showAll = false;
  List<String> searchHistorys;
  TextEditingController textEditingController = TextEditingController();
  NOVEL_SEARCH_PAGE_TYPE type = NOVEL_SEARCH_PAGE_TYPE.PAGE_NOVEL;
  int showSearchHistoryNum = 2; //没有展开时显示的搜索条数
  int maxSearchHistoryNum = 6; //最多记录历史记录调数
  /// 激情小说热门列表
  List<NoveItem> list = [];
  /// 有声小说热门列表
  List<AudioBook> audioList = [];
  PullRefreshController pullController = PullRefreshController();
  int pageNumber = 1;
  int pageSize = 10;

  @override
  NovelSearchState clone() {
    return NovelSearchState()
      ..inputText = inputText
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..showAll = showAll
      ..type = type
      ..list = list
      ..audioList = audioList
      ..pullController = pullController
      ..searchHistorys = searchHistorys
      ..textEditingController = textEditingController
      ..showSearchHistoryNum = showSearchHistoryNum
      ..maxSearchHistoryNum = maxSearchHistoryNum;
  }
}

NovelSearchState initState(Map<String, dynamic> args) {
  return NovelSearchState()
    ..type = args == null ? NOVEL_SEARCH_PAGE_TYPE.PAGE_NOVEL : args['type'];
}
