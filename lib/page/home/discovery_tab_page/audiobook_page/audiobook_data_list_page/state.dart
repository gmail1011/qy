import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';

class AudiobookDataListState implements Cloneable<AudiobookDataListState> {
  PullRefreshController pullRefreshController = PullRefreshController();
  List<AudioBook> list = [];
  var pageSize = 10;
  var pageNumber = 1;

  ///1 主播主页  2 主播收藏列表 3 购买列表  4 收藏列表 5 浏览记录列表 6 搜索
  var type = 1;
  // 主播页面  传主播名字   其他传对应类型
  var typeStr = '';
  @override
  AudiobookDataListState clone() {
    return AudiobookDataListState()
      ..pullRefreshController = pullRefreshController
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..list = list
      ..type = type
      ..typeStr = typeStr;
  }
}

AudiobookDataListState initState(Map<String, dynamic> args) {
  var state = AudiobookDataListState();
  if (args != null) {
    state.type = args['type'] ?? '';
    state.typeStr = args['typeStr'] ?? '';
  }
  return state;
}
