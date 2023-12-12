import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/bang_dan_detail_entity.dart';
import 'package:flutter_app/model/publish_detail_entity.dart';
import 'package:flutter_base/utils/log.dart';

import 'make_video_action.dart';
import 'make_video_state.dart';

Effect<MakeVideoState> buildEffect() {
  return combineEffects(<Object, Effect<MakeVideoState>>{
    Lifecycle.initState: _onInitData,
    Lifecycle.dispose: _onDispose,
  });
}

void _onInitData(Action action, Context<MakeVideoState> ctx) async {
  _getAdsList(action, ctx);
  dynamic publishDetail = await netManager.client.getPublishDetail();
  PublishDetailData entryVideoData =
      PublishDetailData().fromJson(publishDetail);
  ctx.dispatch(MakeVideoActionCreator.getDetail(entryVideoData));

  _getBangDanList(action, ctx);
}

void _getAdsList(Action action, Context<MakeVideoState> ctx) async {
  List<AdsInfoBean> list = await getAdsByType(AdsType.creationCenter);
  ctx.state.adsList = (list ?? []);
}

///获取榜单列表
void _getBangDanList(Action action, Context<MakeVideoState> ctx) async {
  try {
    dynamic entryVideo = await netManager.client.getBangDanList();
    BangDanDetailData entryVideoData = BangDanDetailData().fromJson(entryVideo);
    l.e("getBangDanList-entryVideoData:", "$entryVideoData");
    ctx.dispatch(
        MakeVideoActionCreator.setBangDanList(entryVideoData?.list ?? []));
  } catch (e) {
    l.e("getBangDanList-error:", "$e");
  }
}

void _onDispose(Action action, Context<MakeVideoState> ctx) {}
