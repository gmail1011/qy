import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/bang_dan_detail_entity.dart';

enum ZuoPinAction { action , getDetail}

class ZuoPinActionCreator {
  static Action onAction() {
    return const Action(ZuoPinAction.action);
  }

  static Action onGetail(BangDanDetailData entryVideoData) {
    return  Action(ZuoPinAction.getDetail,payload: entryVideoData);
  }
}
