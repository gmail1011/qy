import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class UserDynamicPostState extends MutableSource implements Cloneable<UserDynamicPostState> {
  List<PostItemState> videoList = [];

  int pageNumber = 0;

  int pageSize = 20;

  int uid;

  bool hasNext;

  bool loadComplete = false;

  EasyRefreshController controller = EasyRefreshController();

  String uniqueId;

  ///控制请求状态，未返回时不可再进行请求
  bool requestStatus = false;
  bool showToTopBtn = false;
  @override
  UserDynamicPostState clone() {
    return UserDynamicPostState()
      ..videoList = videoList
      ..pageSize = pageSize
      ..uid = uid
      ..requestStatus = requestStatus
      ..uniqueId = uniqueId
      ..loadComplete = loadComplete
      ..hasNext = hasNext
      ..controller = controller
      ..pageNumber = pageNumber
      ..showToTopBtn = showToTopBtn;
  }

  @override
  Object getItemData(int index) {
    return videoList[index];
  }

  @override
  String getItemType(int index) {
    return 'post_item';
  }

  @override
  int get itemCount => videoList?.length??0;

  @override
  void setItemData(int index, Object data) {
    videoList[index] = data;
  }
}

UserDynamicPostState initState(Map<String, dynamic> args) {
  UserDynamicPostState newState = UserDynamicPostState();
  if(args.containsKey('uid')) {
    newState.uid = args['uid'];
  }
  newState.uniqueId = args['uniqueId'];
  return newState;
}
