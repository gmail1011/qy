import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'state.dart';

Effect<EditSummaryState> buildEffect() {
  return combineEffects(<Object, Effect<EditSummaryState>>{
    EditSummaryAction.editSummary: _editSummary,
    Lifecycle.dispose: _dispose,
  });
}

void _editSummary(Action action, Context<EditSummaryState> ctx) async {
  String summaryStr = ctx.state.editingController?.text?.trim() ?? "";

  try {
    if (summaryStr.isEmpty) {
      showToast(msg: "简介不能为空～");
      return;
    }
    Map<String, dynamic> editInfo = {'summary': summaryStr};
    var userInfo = await GlobalStore.updateUserInfo(editInfo);
    if (null != userInfo) {
      showToast(msg: "更新简介成功");
      ctx.state.editingController?.clear();
      ctx.dispatch(EditSummaryActionCreator.updateUI());
    }
  } catch (e) {
    l.e("_editNickName-error:", "$e");
    showToast(msg: "更新简介失败");
  }
}

void _dispose(Action action, Context<EditSummaryState> ctx) {
  ctx.state.editingController?.dispose();
}
