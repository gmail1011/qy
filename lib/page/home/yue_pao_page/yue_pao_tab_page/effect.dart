import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/announce_liao_ba_entity.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<YuePaoTabState> buildEffect() {
  return combineEffects(<Object, Effect<YuePaoTabState>>{
    YuePaoTabAction.action: _onAction,
    Lifecycle.initState: _onAction,
  });
}

void _onAction(Action action, Context<YuePaoTabState> ctx) async{
 // var list = await getAdsByType(AdsType.girl);
 // ctx.dispatch(YuePaoTabActionCreator.onGetAds(list ?? []));

  try {
    AnnounceLiaoBaData specialModel = await netManager.client.getAnnounce();
    StringBuffer stringBuffer = new StringBuffer();
    specialModel.announcement.forEach((element) {
      stringBuffer.write(element);
    });
    ctx.dispatch(YuePaoTabActionCreator.onGetAnnounce(stringBuffer.toString()));
  } catch (e) {

  }
}
