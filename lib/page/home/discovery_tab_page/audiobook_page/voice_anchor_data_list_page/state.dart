import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';

class VoiceAnchorDataListState implements Cloneable<VoiceAnchorDataListState> {
  PullRefreshController pullRefreshController = PullRefreshController();
  List<Anchor> list = [];
  var pageSize = 10;
  var pageNumber = 1;

  ///1 主播列表  2 主播收藏列表
  var type = 1;

  @override
  VoiceAnchorDataListState clone() {
    return VoiceAnchorDataListState()
      ..pullRefreshController = pullRefreshController
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..type = type
      ..list = list;
  }
}

VoiceAnchorDataListState initState(Map<String, dynamic> args) {
  return VoiceAnchorDataListState()
    ..type = args == null ? 1 : args['type'] ?? 0;
}
