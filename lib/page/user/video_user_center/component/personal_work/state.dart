import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_work/component/state.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class UserWorkPostState extends MutableSource implements Cloneable<UserWorkPostState> {
  List<WorkItemState> videoList = [];

  int pageNumber = 0;

  int pageSize = 15;

  int uid;

  bool hasNext;

  bool loadComplete = false;

  EasyRefreshController controller = EasyRefreshController();

  String uniqueId;

  MineVideo works = new MineVideo();

  ///控制请求状态，未返回时不可再进行请求
  bool requestStatus = false;

  bool showToTopBtn = false;



  @override
  UserWorkPostState clone() {
    return UserWorkPostState()
      ..videoList = videoList
      ..pageSize = pageSize
      ..uid = uid
      ..requestStatus = requestStatus
      ..uniqueId = uniqueId
      ..loadComplete = loadComplete
      ..hasNext = hasNext
      ..controller = controller
      ..pageNumber = pageNumber
      ..works = works
      ..showToTopBtn = showToTopBtn;
  }

  @override
  Object getItemData(int index) {
    return videoList[index];
  }

  @override
  String getItemType(int index) {
    return 'workItem';
  }

  @override
  int get itemCount => videoList.length;

  @override
  void setItemData(int index, Object data) {
    videoList[index] = data;
  }
}

UserWorkPostState initState(Map<String, dynamic> args) {
  UserWorkPostState newState = UserWorkPostState();
  if(args.containsKey('uid')) {
    newState.uid = args['uid'];
  }
  newState.uniqueId = args['uniqueId'];
  return newState;
}
