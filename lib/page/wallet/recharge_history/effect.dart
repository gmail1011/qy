import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/recharge_history_model.dart';
import 'package:flutter_app/model/recharge_history_obj.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';

Effect<RechargeHistoryState> buildEffect() {
  return combineEffects(<Object, Effect<RechargeHistoryState>>{
    RechargeHistoryAction.backAction: _backAction,
    RechargeHistoryAction.requestData: _requestData,
    Lifecycle.initState: _requestData,
  });
}

void _backAction(Action action, Context<RechargeHistoryState> ctx) {
  safePopPage();
}

void _requestData(Action action, Context<RechargeHistoryState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () async {
    requestData(ctx);
    //eaglePage(ctx.state.selfId(),
          //sourceId: ctx.state.eagleId(ctx.context));
  });
  
}

void requestData(Context<RechargeHistoryState> ctx) async {
  // Map<String, dynamic> map = Map();
  // map['pageNumber'] = ctx.state.pageNumber;
  // map['pageSize'] = ctx.state.pageSize;
  int pageNumber = ctx.state.pageNumber;
  int pageSize = ctx.state.pageSize;
  try {
    RechargeHistoryObj list =
        await netManager.client.getRechargeHistory(pageNumber, pageSize);
    ctx.dispatch(RechargeHistoryActionCreator.onRequestData(list.list));
  } catch (e) {
    l.e('getRechargeHistory', e.toString());
    //失败
    ctx.dispatch(RechargeHistoryActionCreator.onError(e.toString()));
    showToast(msg: e.toString() ?? '');
  }
  // getRechargeHistory(map).then((res) {
  //   if (res.code == 200) {
  //     // PagedList list = PagedList.fromJson<RechargeHistoryModel>(res.data);
  //     PagedList list = PagedList.fromJson(res.data);
  //     ctx.dispatch(RechargeHistoryActionCreator.onRequestData(
  //         RechargeHistoryModel.toList(list.list)));
  //   } else {
  //     //失败
  //     ctx.dispatch(RechargeHistoryActionCreator.onError(res.msg));
  //     showToast(msg: res.msg ?? '');
  //   }
  // });
}
