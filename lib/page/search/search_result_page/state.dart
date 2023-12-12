import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class SearchResultState
    with EagleHelper
    implements Cloneable<SearchResultState> {
  TabController tabController;
  TextEditingController editingController;
  var myTabs = <Tab>[
    Tab(text: "视频"),
    Tab(text: "帖子"),
  ];
  String keywords = '';
  @override
  SearchResultState clone() {
    return SearchResultState()
      ..tabController = tabController
      ..editingController = editingController
      ..keywords = keywords;
  }
}

SearchResultState initState(Map<String, dynamic> args) {
  var state = SearchResultState();
  state.tabController =
      TabController(initialIndex: 0, length: 2, vsync: ScrollableState());
  if (args != null) {
    state.keywords = args['keywords'] ?? '';
  }
  state.editingController = TextEditingController.fromValue(TextEditingValue(
      text: state.keywords ?? '',
      selection: TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.downstream,
          offset: (state.keywords ?? '').length))));

  return state;
}
