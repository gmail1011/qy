import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/reward_list_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RewardLogState with EagleHelper implements  Cloneable<RewardLogState> {

  RefreshController refreshController = RefreshController();
  List<RewardItem> list = [];

  // 页数
  int pageNum = 1;

  @override
  RewardLogState clone() {
    return RewardLogState()
    ..refreshController = refreshController
    ..list = list
    ..pageNum = pageNum;
  }
}

RewardLogState initState(Map<String, dynamic> args) {
  return RewardLogState();
}
