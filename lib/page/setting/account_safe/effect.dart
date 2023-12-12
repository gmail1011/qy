import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';

Effect<AccountSafeState> buildEffect() {
  return combineEffects(<Object, Effect<AccountSafeState>>{
    AccountSafeAction.backAction: _backAction,
    AccountSafeAction.qrLogin: _qrLogin,
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<AccountSafeState> ctx){
  Future.delayed(Duration(milliseconds: 200),(){
    //eaglePage(ctx.state.selfId(),
          //sourceId: ctx.state.eagleId(ctx.context));
  });
  
}

void _backAction(Action action, Context<AccountSafeState> ctx) {
  safePopPage();
}

void _qrLogin(Action action, Context<AccountSafeState> ctx) async {
  String qr = action.payload;
  if (TextUtil.isEmpty(qr)) {
    showToast(msg: Lang.INVALID_QR_CODE);
    return;
  }
  // 清除旧的token
  netManager.setToken(null);
  // 生成新的ua
  netManager.userAgent(await getDeviceId());
  UserInfoModel userInfo = await GlobalStore.loginByQr(qr);
  if (null == userInfo) {
    return;
  }
  _handleLoginSuccess(action, ctx, userInfo, qr);
}

_handleLoginSuccess(Action action, Context<AccountSafeState> ctx,
    UserInfoModel userInfo, String qrCode) async {
  Navigator.pushNamedAndRemoveUntil(
    ctx.context,
    PAGE_HOME,
    (route) => route == null,
  );
}
