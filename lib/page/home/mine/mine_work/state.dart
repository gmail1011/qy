import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

enum MineWorkPageType {
  WORK_PAGE, //作品页面
  DYNAMIC_PAGE, //动态页面
}

class MineWorkState extends MutableSource with EagleHelper implements Cloneable<MineWorkState> {
  List<PostItemState> workStateList = [];
  MineWorkPageType pageType;
  int pageSize = 15;
  int pageNumber = 1;
  MineVideo workVideo;
  bool isLoading = true;
  bool showToTopBtn = false;
  var maxOutOffset;

  EasyRefreshController workController = EasyRefreshController();

  @override
  MineWorkState clone() {
    return MineWorkState()
      ..pageNumber = pageNumber
      ..workVideo = workVideo
      ..workController = workController
      ..workStateList = workStateList
      ..isLoading = isLoading
      ..maxOutOffset = maxOutOffset
      ..showToTopBtn = showToTopBtn
      ..pageType = pageType;
  }

  @override
  Object getItemData(int index) {
    return workStateList[index];
  }

  @override
  String getItemType(int index) {
    if (pageType == MineWorkPageType.WORK_PAGE) {
      return "work_item";
    } else {
      return "post_item";
    }
  }

  @override
  int get itemCount => workStateList?.length ?? 0;

  @override
  void setItemData(int index, Object data) {
    if (data is Cloneable) {
      workStateList[index] = data.clone();
    } else {
      workStateList[index] = data;
    }
  }
}

MineWorkState initState(MineWorkPageType pageType) {
  return MineWorkState()..pageType = pageType;
}
