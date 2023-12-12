import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/bang_dan_detail_entity.dart';
import 'package:flutter_app/model/publish_detail_entity.dart';

enum MakeVideoAction {
  getDetail,
  setCountDownTime,
  shouyi,
  zuopin,
  bangDanList,
}

class MakeVideoActionCreator {
  static Action getDetail(PublishDetailData entryVideoData) {
    return Action(MakeVideoAction.getDetail, payload: entryVideoData);
  }

  static Action setCountDonwTime(String entryVideoData) {
    return Action(MakeVideoAction.setCountDownTime, payload: entryVideoData);
  }

  static Action shouYi(List<PublishDetailDataLeaderboardsMembers> shouyi) {
    return Action(MakeVideoAction.shouyi, payload: shouyi);
  }

  static Action zuoPin(List<PublishDetailDataLeaderboardsMembers> shouyi) {
    return Action(MakeVideoAction.zuopin, payload: shouyi);
  }

  static Action setBangDanList(List<BangDanRankType> list) {
    return Action(MakeVideoAction.bangDanList, payload: list);
  }
}
