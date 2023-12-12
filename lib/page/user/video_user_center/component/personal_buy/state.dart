import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'component/state.dart';

class UserBuyPostState extends MutableSource implements Cloneable<UserBuyPostState> {
  List<BuyItemState> videoList = [];

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
  UserBuyPostState clone() {
    return UserBuyPostState()
      ..videoList = videoList
      ..loadComplete = loadComplete
      ..requestStatus = requestStatus
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..uid = uid
      ..uniqueId = uniqueId
      ..hasNext = hasNext
      ..showToTopBtn = showToTopBtn;
  }

  @override
  Object getItemData(int index) {
    return videoList[index];
  }

  @override
  String getItemType(int index) {
    return 'buyItem';
  }

  @override
  int get itemCount => videoList.length;

  @override
  void setItemData(int index, Object data) {
    videoList[index] = data;
  }
}

UserBuyPostState initState(Map<String, dynamic> args) {
  UserBuyPostState newState = UserBuyPostState();
  assert(args.containsKey('uniqueId'));
  newState.uniqueId = args['uniqueId'];
  if(args.containsKey('uid')) {
    newState.uid = args['uid'];
  }
  return newState;
}
