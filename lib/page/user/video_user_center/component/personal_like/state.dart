import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_like/component/state.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class UserLikePostState extends MutableSource implements Cloneable<UserLikePostState> {
  List<LikeItemState> videoList = [];

  EasyRefreshController controller = EasyRefreshController();

  bool hasNext;

  bool loadComplete = false;

  int pageNumber = 0;

  int pageSize = 15;

  int uid;

  String uniqueId;

  bool requestStatus = false;
  bool showToTopBtn = false;
  @override
  UserLikePostState clone() {
    return UserLikePostState()
      ..videoList = videoList
      ..controller = controller
      ..hasNext = hasNext
      ..requestStatus = requestStatus
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..uniqueId = uniqueId
      ..uid = uid
      ..loadComplete = loadComplete
      ..showToTopBtn = showToTopBtn;
  }

  @override
  Object getItemData(int index) {
    return videoList[index];
  }

  @override
  String getItemType(int index) {
    return 'likeItem';
  }

  @override
  int get itemCount => videoList.length;

  @override
  void setItemData(int index, Object data) {
    videoList[index] = data;
  }
}

UserLikePostState initState(Map<String, dynamic> args) {
  UserLikePostState newState = UserLikePostState();
  if(args.containsKey('uid')) {
    newState.uid = args['uid'];
  }
  assert(args.containsKey('uniqueId'));
  newState.uniqueId = args['uniqueId'];
  return newState;
}
