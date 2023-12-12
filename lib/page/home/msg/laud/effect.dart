import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/message/laud_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_base/utils/log.dart';
import '../../../../common/net2/net_manager.dart';
import 'action.dart';
import 'state.dart';

Effect<LaudState> buildEffect() {
  return combineEffects(<Object, Effect<LaudState>>{
    Lifecycle.initState: _initState,
  });
}

void _initState(Action action, Context<LaudState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () async {
    getCommentReply(ctx);
    //eaglePage(ctx.state.selfId(),
         // sourceId: ctx.state.eagleId(ctx.context));
  });
  
}

/// 获取
getCommentReply(Context<LaudState> ctx) async {
  // Map<String, dynamic> map = Map();
  // map['pageNumber'] = ctx.state.pageNumber;
  // map['pageSize'] = ctx.state.pageSize;
  // BaseResponse res = await HttpManager().get(Address.LIKE_LIST, params: map);
  try {
    int pageNumber = ctx.state.pageNumber;
    int pageSize = ctx.state.pageSize;
    LaudModel laudModel =
        await netManager.client.getLikeList(pageNumber, pageSize);
    ctx.dispatch(LaudActionCreator.onLoadLaudList(
        laudModel?.list ??= [], laudModel?.hasNext ??= false));
  } catch (e) {
    l.e('getLikeList', e.toString());
    showToast(msg: e.toString() ?? '');
  }
  // if (res.code == 200) {
  //   ///toList
  //   LaudModel laudModel = LaudModel.fromMap(res.data);
  //   ctx.dispatch(LaudActionCreator.onLoadLaudList(
  //       laudModel?.list ??= [], laudModel?.hasNext ??= false));
  // } else {
  //   showToast(msg: res.msg ?? '');
  // }
}
