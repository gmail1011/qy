import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../module_type.dart';

class PictureWordState implements Cloneable<PictureWordState> {
  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  /// 图文页码
  int picturePageNumber = 1;

  /// 分页大小
  final int pageSize = Config.PAGE_SIZE;

  /// 图文列表
  List<VideoModel> pictureVideoModelList = [];

  String videoErrorMsg = "";

  ///是否还有下一页
  bool hasNext = true;
  bool isPicWordEditModel = false;
  ModuleType moduleType;

  @override
  PictureWordState clone() {
    return PictureWordState()
      ..isPicWordEditModel = isPicWordEditModel
      ..picturePageNumber = picturePageNumber
      ..pictureVideoModelList = pictureVideoModelList
      ..videoErrorMsg = videoErrorMsg
      ..refreshController = refreshController
      ..hasNext = hasNext
      ..moduleType = moduleType
      ..requestController = requestController;
  }
}

PictureWordState initState(Map<String, dynamic> args) {
  return PictureWordState()..moduleType = args["type"];
}
