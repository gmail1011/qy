import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'component/state.dart';

class MineLikePostState extends MutableSource with EagleHelper implements Cloneable<MineLikePostState> {
  List<MineLikeItemState> videoList = [];

  //EasyRefreshController controller = EasyRefreshController();

  bool hasNext;

  bool loadComplete = false;

  int pageNumber = 0;

  int pageSize = 100;

  int uid = 0;

  String uniqueId;

  bool requestStatus = false;
  var maxOutOffset;
  bool showToTopBtn = false;

  MineVideo works;

  RefreshController controller = RefreshController();

  ScrollController scrollController;

  @override
  MineLikePostState clone() {
    return MineLikePostState()
      ..videoList = videoList
      ..controller = controller
      ..hasNext = hasNext
      ..requestStatus = requestStatus
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..uniqueId = uniqueId
      ..uid = uid
      ..loadComplete = loadComplete
      ..maxOutOffset = maxOutOffset
      ..works = works
      ..scrollController = scrollController
      ..showToTopBtn = showToTopBtn;
  }

  @override
  Object getItemData(int index) {
    return videoList[index];
  }

  @override
  String getItemType(int index) {
    return 'mineLikeItem';
  }

  @override
  int get itemCount => videoList.length;

  @override
  void setItemData(int index, Object data) {
    videoList[index] = data;
  }
}

MineLikePostState initState(Map<String, dynamic> args) {
  MineLikePostState newState = MineLikePostState();
  newState.scrollController = args["scrollController"];
  return newState;
}
