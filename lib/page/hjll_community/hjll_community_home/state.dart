import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/global_store/state.dart';

class HjllCommunityHomeState extends GlobalBaseState implements Cloneable<HjllCommunityHomeState> {
  TabController tabController =
      TabController(length: Config.communityDataTags.length, vsync: ScrollableState());

  @override
  HjllCommunityHomeState clone() {
    return HjllCommunityHomeState()..tabController = tabController;
  }
}

HjllCommunityHomeState initState(Map<String, dynamic> args) {
  return HjllCommunityHomeState();
}
