import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'state.dart';

Effect<EditNickNameState> buildEffect() {
  return combineEffects(<Object, Effect<EditNickNameState>>{
    Lifecycle.dispose: _dispose,
    EditNickNameAction.editNickName: _editNickName,
  });
}

/// 修改用户昵称
void _editNickName(Action action, Context<EditNickNameState> ctx) async {
  String nickNameStr = ctx.state.nickController?.text?.trim() ?? "";

  try {
    if (nickNameStr.isEmpty) {
      showToast(msg: "昵称不能为空～");
      return;
    }
    if (nickNameStr.length > 9) {
      showToast(msg: "昵称不能超过9个字符～");
      return;
    }
    Map<String, dynamic> editInfo = {
      'name': nickNameStr,
    };
    var userInfo = await GlobalStore.updateUserInfo(editInfo);
    if (null != userInfo) {
      showToast(msg: "更新昵称成功");
      ctx.state.nickController?.clear();
      ctx.dispatch(EditNickNameActionCreator.updateUI());
    }
  } catch (e) {
    l.e("_editNickName-error:", "$e");
    showToast(msg: "更新昵称失败");
  }
}

void _dispose(Action action, Context<EditNickNameState> ctx) async {
  ctx.state.nickController?.dispose();
}
