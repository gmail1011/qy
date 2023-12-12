import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/search/hot_search_list/hot_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DiscoveryState with EagleHelper implements Cloneable<DiscoveryState> {
  List<AreaModel> areaList;
  List<FindModel> findList;
  RefreshController refreshController = RefreshController();
  int pageNumber = 1;
  int pageSize = 10;
  @override
  DiscoveryState clone() {
    return DiscoveryState()
      ..areaList = areaList
      ..findList = findList
      ..pageSize = pageSize
      ..pageNumber = pageNumber
      ..refreshController = refreshController;
  }
}

DiscoveryState initState(Map<String, dynamic> args) {
  return DiscoveryState()
    ..findList = args['findList']
    ..areaList = args['areaList'];
}
