import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/bang_dan_detail_entity.dart';
import 'package:flutter_base/utils/log.dart';

import 'zuo_pin_action.dart';
import 'zuo_pin_state.dart';

Effect<ZuoPinState> buildEffect() {
  return combineEffects(<Object, Effect<ZuoPinState>>{
    Lifecycle.initState: _onInitData,
  });
}

void _onInitData(Action action, Context<ZuoPinState> ctx) async {
  try {
    dynamic entryVideo = await netManager.client.getBangDanList();
    BangDanDetailData entryVideoData = BangDanDetailData().fromJson(entryVideo);
    ctx.dispatch(ZuoPinActionCreator.onGetail(entryVideoData));
  } catch (e) {
    l.e("getBangDanList-error:", "$e");
  }
}
