import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/home/yue_pao_page/recording_page/view_item.dart';

class RecordingState implements Cloneable<RecordingState> {


  List<String> tabList = [Lang.COLLECTION_RECORD,Lang.BUY_HISTORY,Lang.RESERVE_HISTORY];
  List<String> tabTitleList = ["樓鳳","裸聊"];
  List<ItemView> tabView = [
    ItemView(RecordingType.favoritesLog),
    ItemView(RecordingType.buyLog),
    ItemView(RecordingType.reserveLog),
  ]; 
  TabController tabBarController;
  TabController tabBarTitleController;
  @override
  RecordingState clone() {
    return RecordingState();
    // ..louFengList = louFengList;
  }
}

RecordingState initState(Map<String, dynamic> args) {
  return RecordingState()
  ..tabBarController = TabController(length: 3, vsync: ScrollableState(),initialIndex: 0)..tabBarTitleController = TabController(length: 2, vsync: ScrollableState(),initialIndex: 0);
}
