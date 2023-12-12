import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/message/message_type_model.dart';
import 'package:flutter_base/flutter_base.dart';
import 'action.dart';
import 'state.dart';

Effect<MsgState> buildEffect() {
  return combineEffects(<Object, Effect<MsgState>>{
    Lifecycle.initState: _initState,
    MsgAction.loadMessageTypeAction: _loadMessageType,
  });
}

void _initState(Action action, Context<MsgState> ctx) async {
  _getMessageType(ctx);
 // List<AdsInfoBean> adList = await getAdsByType(AdsType.msgType);
 // if (ArrayUtil.isNotEmpty(adList)) {
 //   ctx.dispatch(MsgActionCreator.getAdsOkay(adList[0]));
 // }
  // Future.delayed(Duration(milliseconds: 200)).then((_) {
  //   eaglePage(ctx.state.selfId(),
  //         sourceId: ctx.state.eagleId(ctx.context));
  // });
}

void _loadMessageType(Action action, Context<MsgState> ctx) {
  _getMessageType(ctx);
}

/// 获取
_getMessageType(Context<MsgState> ctx) async {
  // BaseResponse res = await HttpManager().get(Address.NOTICE_TYPE_LIST);
  try {
    MessageTypeModel messageTypeModel = await netManager.client.getNoticeTypeList();
    ctx.dispatch(MsgActionCreator.onLoadMessageType(messageTypeModel));
  } catch (e) {
    l.e('getNoticeTypeList==', e.toString());
  }
  // if (res.code == 200) {
  //   ///toList
  //   MessageTypeModel messageTypeModel = MessageTypeModel.fromJson(res.data);
  //   ctx.dispatch(MsgActionCreator.onLoadMessageType(messageTypeModel));
  // } else {}
}
