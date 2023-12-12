import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/bang_dan_detail_entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ZuoPinState implements Cloneable<ZuoPinState> {

  int pageNum = 1;
  int pageSize = 20;

  BangDanDetailData entryVideoData;

  RefreshController refreshController = new RefreshController();

  @override
  ZuoPinState clone() {
    return ZuoPinState()..entryVideoData = entryVideoData;
  }
}

ZuoPinState initState(Map<String, dynamic> args) {
  return ZuoPinState();
}
