import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';

class CommunityTabState implements Cloneable<CommunityTabState> {
  TabController tabController;
  List<TagDetailModel> community = [];

  @override
  CommunityTabState clone() {
    return CommunityTabState()
      ..community = community
      ..tabController = tabController;
  }
}

CommunityTabState initState(Map<String, dynamic> args) {
  var communityList = (args == null ? [] : (args["community"] ?? []));
  TagDetailModel tagDetailModel = TagDetailModel();
  tagDetailModel.id = "最新";
  tagDetailModel.name = "最新";
  communityList.insert(0, tagDetailModel);
  return CommunityTabState()..community = communityList;
}
