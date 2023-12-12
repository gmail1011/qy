import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/search/hot_search_list/hot_model.dart';

class DiscoveryTabState implements Cloneable<DiscoveryTabState> {
  TabController tabController = TabController(
    length: 5,
    vsync: ScrollableState(),
  );
  List<AreaModel> areaList;
  List<FindModel> findList;
  int index = -1;


  String selectedAge;
  List<String> ageOptions = [
    '全部',
    '18-25',
    '26-30',
    '31以上',
  ];


  String selectedHeight;
  List<String> heightOptions = [
    '全部',
    '155cm-165cm',
    '166cm-175cm',
    '176cm以上',
  ];



  String selectedBust;
  List<String> bustOptions = [
    '全部',
    'C',
    'D',
    'E',
    'F',
  ];


  @override
  DiscoveryTabState clone() {
    return DiscoveryTabState()
      ..tabController = tabController
      ..areaList = areaList
      ..findList = findList
      ..selectedAge = selectedAge
      ..ageOptions = ageOptions
      ..selectedHeight = selectedHeight
      ..heightOptions = heightOptions
      ..selectedBust = selectedBust
      ..bustOptions = bustOptions
      ..index = index
    ;
  }
}

DiscoveryTabState initState(Map<String, dynamic> args) {
  return DiscoveryTabState()
    ..findList = args['findList']
    ..areaList = args['areaList'];
}
