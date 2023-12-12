import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/video_item_commponent/state.dart';
import 'package:flutter_app/page/video/video_list_model/abs_video_list_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class MainPlayerListState extends MutableSource
    with EagleHelper implements Cloneable<MainPlayerListState> {
  ///视频列表
  List<VideoItemState> videoList = [];

  bool initDataResult;

  var curIndex = 0;

  AdsInfoBean adsInfoBean;

  ///是否展示小广告的大图
  bool isShowBigAds = true;

  String uniqueId;

  /// 数据加载模型
  AbsVideoListModel videoListModel;

  PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  bool isRequesting = false;

  VideoListType type;

  /// 监听外部的自动播放控制
  Function autoPlayListener;

  @override
  MainPlayerListState clone() {
    return MainPlayerListState()
      ..videoList = videoList
      ..pageController = pageController
      ..initDataResult = initDataResult
      ..adsInfoBean = adsInfoBean
      ..isShowBigAds = isShowBigAds
      ..curIndex = curIndex
      ..uniqueId = uniqueId
      ..videoListModel = videoListModel
      ..type = type
      ..isRequesting = isRequesting;
  }

  @override
  Object getItemData(int index) {
    return videoList[index];
  }

  @override
  String getItemType(int index) {
    return 'video_item';
  }

  @override
  int get itemCount => videoList?.length ?? 0;

  @override
  void setItemData(int index, Object data) {
    if (data is Cloneable) {
      videoList[index] = data.clone();
    } else {
      videoList[index] = data;
    }
  }
}

MainPlayerListState initState(Map<String, dynamic> args) {
  var type = (null != args) ? args[KEY_VIDEO_LIST_TYPE] : null;
  assert(null != type);
  var videoListModel = AbsVideoListModel.create(type);
  return MainPlayerListState()
    ..uniqueId = args['uniqueId']
    ..type = type
    ..videoListModel = videoListModel;
}
