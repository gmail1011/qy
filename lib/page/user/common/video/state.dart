import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../module_type.dart';

class LongVideoState implements Cloneable<LongVideoState> {
  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  /// 视频页码
  int videoPageNumber = 1;

  /// 分页大小
  final int pageSize = Config.PAGE_SIZE;

  /// 视频列表
  List<VideoModel> videoModelList = [];
  String videoErrorMsg = "";
  bool isVideoEditModel = false;

  ///是否还有下一页
  bool hasNext = true;

  ///获取视频类型
  ModuleType moduleType;

  @override
  LongVideoState clone() {
    return LongVideoState()
      ..videoPageNumber = videoPageNumber
      ..videoModelList = videoModelList
      ..videoErrorMsg = videoErrorMsg
      ..isVideoEditModel = isVideoEditModel
      ..refreshController = refreshController
      ..hasNext = hasNext
      ..moduleType = moduleType
      ..requestController = requestController;
  }
}

LongVideoState initState(Map<String, dynamic> args) {
  return LongVideoState()
    ..isVideoEditModel = false
    ..moduleType = args["type"];
}
