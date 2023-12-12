import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/city_detail_model.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class MyFavoriteState with EagleHelper implements Cloneable<MyFavoriteState> {
  TabController tabController =
      new TabController(length: 5, vsync: ScrollableState());

  /// 视频页码
  int videoPageNumber = 1;

  /// 地点页码
  int locationPageNumber = 1;

  /// 话题页码
  int tagPageNumber = 1;

  /// 分页大小
  final int pageSize = Config.PAGE_SIZE;

  /// 视频列表
  List<VideoModel> videoModelList = [];

  /// 地点列表
  List<CityDetailModel> cityModelList = [];

  /// 话题列表
  List<TagDetailModel> tagModelList = [];

  bool videoError = true;
  String videoErrorMsg = "";
  bool cityError = true;
  String cityErrorMsg = "";
  bool tagError = true;
  String tagErrorMsg = "";
  bool isVideoEditModel = false;
  bool isShortVideoEditModel = false;
  bool isPicWordEditModel = false;
  bool isTagEditModel = false;

  MyFavoriteState();

  @override
  MyFavoriteState clone() {
    return MyFavoriteState()
      ..videoPageNumber = videoPageNumber
      ..locationPageNumber = locationPageNumber
      ..tagPageNumber = tagPageNumber
      ..videoModelList = videoModelList
      ..cityModelList = cityModelList
      ..tagModelList = tagModelList
      ..videoError = videoError
      ..videoErrorMsg = videoErrorMsg
      ..cityError = cityError
      ..cityErrorMsg = cityErrorMsg
      ..tagError = tagError
      ..tagErrorMsg = tagErrorMsg
      ..tabController = tabController
      ..isVideoEditModel = isVideoEditModel
      ..isShortVideoEditModel = isShortVideoEditModel
      ..isPicWordEditModel = isPicWordEditModel
      ..isTagEditModel = isTagEditModel;
  }
}

MyFavoriteState initState(Map<String, dynamic> args) {
  return MyFavoriteState()..isVideoEditModel = false;
}
