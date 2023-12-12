import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/message/laud_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class LaudState with EagleHelper implements Cloneable<LaudState> {
  final int pageSize = Config.PAGE_SIZE;
  int pageNumber = 1;

  List<LaudItem> laudModelList;

  List<VideoModel> videoModelList = [];

  bool hasNext = false;

  @override
  LaudState clone() {
    return LaudState()
      ..pageNumber = pageNumber
      ..hasNext = hasNext
      ..videoModelList = videoModelList
      ..laudModelList = laudModelList;
  }
}

LaudState initState(Map<String, dynamic> args) {
  return LaudState();
}
