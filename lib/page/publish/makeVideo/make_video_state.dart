import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/bang_dan_detail_entity.dart';
import 'package:flutter_app/model/publish_detail_entity.dart';

class MakeVideoState implements Cloneable<MakeVideoState> {
  String countDownTime;

  PublishDetailData entryVideoData;
  List<BangDanRankType> rankTypeList = [];
  List<AdsInfoBean> adsList = [];

  String taskID;

  @override
  MakeVideoState clone() {
    return MakeVideoState()
      ..countDownTime = countDownTime
      ..entryVideoData = entryVideoData
      ..rankTypeList = rankTypeList
      ..taskID = taskID
      ..adsList = adsList;
  }
}

MakeVideoState initState(Map<String, dynamic> args) {
  return MakeVideoState()..taskID = args != null ? (args["taskID"] ?? "") : "";
}
