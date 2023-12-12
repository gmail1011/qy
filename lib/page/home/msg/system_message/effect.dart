import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/message/message_obj_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import '../../../../common/manager/cs_manager.dart';
import 'action.dart';
import 'state.dart';

Effect<SystemMessageState> buildEffect() {
  return combineEffects(<Object, Effect<SystemMessageState>>{
    SystemMessageAction.backAction: _backAction,
    Lifecycle.initState: _loadMessageType,
    SystemMessageAction.onOpenService: _onOpenService,
  });
}

void _backAction(Action action, Context<SystemMessageState> ctx) {
  safePopPage();
}

///进入客服系统
void _onOpenService(Action action, Context<SystemMessageState> ctx) async {
  csManager.openServices(ctx.context);
}

void _loadMessageType(Action action, Context<SystemMessageState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () async {
    _getMessageType(ctx);
    //eaglePage(ctx.state.selfId(),
         // sourceId: ctx.state.eagleId(ctx.context));
  });
  
}

/// 获取
_getMessageType(Context<SystemMessageState> ctx) async {
  // Map<String, dynamic> map = Map();
  // map['sender'] = ctx.state.messageType;
  // map['pageNumber'] = ctx.state.pageNumber++;
  // map['pageSize'] = ctx.state.pageSize;
  // BaseResponse res = await HttpManager().get(Address.NOTICE_LIST, params: map);
  try {
    String sender = ctx.state.messageType;
    int pageNumber = ctx.state.pageNumber++;
    int pageSize = ctx.state.pageSize;
    MessageObjModel messageObjModel = await netManager.client.getNoticeList(pageNumber, pageSize, sender);
    ctx.dispatch(SystemMessageActionCreator.onLoadMessage(
        messageObjModel.list, messageObjModel.hasNext));
  } catch (e) {
    l.e('getNoticeList==', e.toString());
  }
  // if (res.code == 200) {
  //   ///toList
  //   PagedList list = PagedList.fromJson(res.data);
  //   ctx.dispatch(SystemMessageActionCreator.onLoadMessage(
  //       MessageModel.toList(list.list), list.hasNext));
  // }
}
