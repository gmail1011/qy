import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TopicState implements Cloneable<TopicState> {
  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  /// 话题列表
  List<TagDetailModel> tagModelList = [];
  int pageNumer = 1;
  final int pageSize = Config.PAGE_SIZE;

  bool isTagEditModel = false;
  bool tagError = true;

  ///是否还有下一页
  bool hasNext = true;

  @override
  TopicState clone() {
    return TopicState()
      ..pageNumer = pageNumer
      ..isTagEditModel = isTagEditModel
      ..tagError = tagError
      ..hasNext = hasNext
      ..tagModelList = tagModelList
      ..refreshController = refreshController
      ..requestController = requestController;
  }
}

TopicState initState(Map<String, dynamic> args) {
  return TopicState()..isTagEditModel = false;
}
