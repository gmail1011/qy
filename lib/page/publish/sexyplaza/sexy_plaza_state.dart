import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class SexyPlazaState extends MutableSource
    implements Cloneable<SexyPlazaState> {
  List<AdsInfoBean> adsList = [];

  int pageNum = 1;
  int pageSize = 20;

  List<PostItemState> videoList = [];

  bool loadComplete = false;

  EasyRefreshController controller = EasyRefreshController();

  bool hasNext;

  int uid;

  String uniqueId;

  @override
  SexyPlazaState clone() {
    return SexyPlazaState()
      ..adsList = adsList
      ..pageNum = pageNum
      ..pageSize = pageSize
      ..videoList = videoList
      ..controller = controller
      ..hasNext = hasNext
      ..uid = uid
      ..uniqueId = uniqueId
      ..loadComplete = loadComplete;
  }

  @override
  Object getItemData(int index) {
    // TODO: implement getItemData
    return videoList[index];
  }

  @override
  String getItemType(int index) {
    // TODO: implement getItemType
    return 'post_item';
  }

  @override
  // TODO: implement itemCount
  int get itemCount => videoList?.length??0;

  @override
  void setItemData(int index, Object data) {
    // TODO: implement setItemData
    videoList[index] = data;
  }
}

SexyPlazaState initState(Map<String, dynamic> args) {
  SexyPlazaState newState = SexyPlazaState();
  /*if(args.containsKey('uid')) {
    newState.uid = args['uid'];
  }
  newState.uniqueId = args['uniqueId'];*/
  return newState;
}
