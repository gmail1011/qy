import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'component/state.dart';

class MineBuyPostState extends MutableSource with EagleHelper implements Cloneable<MineBuyPostState> {
  List<MineBuyItemState> videoList = [];

  EasyRefreshController controller = EasyRefreshController();

  bool hasNext;

  bool loadComplete = false;

  int pageNumber = 0;

  int pageSize = 15;

  int uid = 0;

  String uniqueId;

  bool requestStatus = false;
  var maxOutOffset;
  bool showToTopBtn = false;

  @override
  MineBuyPostState clone() {
    return MineBuyPostState()
      ..videoList = videoList
      ..loadComplete = loadComplete
      ..requestStatus = requestStatus
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..uid = uid
      ..uniqueId = uniqueId
      ..hasNext = hasNext
      ..maxOutOffset = maxOutOffset
      ..showToTopBtn = showToTopBtn;
  }

  @override
  Object getItemData(int index) {
    return videoList[index];
  }

  @override
  String getItemType(int index) {
    return 'mineBuyItem';
  }

  @override
  int get itemCount => videoList.length;

  @override
  void setItemData(int index, Object data) {
    videoList[index] = data;
  }
}

MineBuyPostState initState(Map<String, dynamic> args) {
  MineBuyPostState newState = MineBuyPostState();
  return newState;
}
