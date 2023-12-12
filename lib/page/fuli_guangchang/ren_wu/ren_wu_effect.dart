import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/task_entity.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'ren_wu_action.dart';
import 'ren_wu_state.dart';

Effect<RenWuState> buildEffect() {
  return combineEffects(<Object, Effect<RenWuState>>{
    RenWuAction.action: _onAction,
    Lifecycle.initState: _initData,
  });
}


///获取二维码数据
void _initData(Action action, Context<RenWuState> ctx) async {
  Future.delayed(Duration(milliseconds: 100), () async {
    try {
      await intDate(ctx);
    } catch (e) {
      //showToast(msg: e.toString());
      return;
    }
  });
}


Future<dynamic> intDate(Context<RenWuState> ctx) async{
  dynamic result = await netManager.client.getTask();
  TaskData taskData = TaskData().fromJson(result);
  ctx.dispatch(RenWuActionCreator.onTask(taskData));
}

void _onAction(Action action, Context<RenWuState> ctx) {
  Future.delayed(Duration(milliseconds: 100), () async {
    try {
      await intDate(ctx);
    } catch (e) {
      //showToast(msg: e.toString());
      return;
    }
  });
}
