import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:r_scan/r_scan.dart';

import 'action.dart';
import 'state.dart';

Effect<RecoverAccountState> buildEffect() {
  return combineEffects(<Object, Effect<RecoverAccountState>>{
    Lifecycle.dispose: _dispose,
    RecoverAccountAction.qrLogin: _qrLogin,
    RecoverAccountAction.photoAlbumSelection: _photoAlbumSelection,
  });
}

///相册扫码
void _photoAlbumSelection(
    Action action, Context<RecoverAccountState> ctx) async {
  try {
    List<Media> image = await ImagePickers.pickerPaths(
      uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
      selectCount: 1,
      showCamera: false,
      cropConfig: CropConfig(enableCrop: false),
    );
    if ((image ?? []).isNotEmpty) {
      RScanResult result = await RScan.scanImagePath(image[0].path);
      if (result?.message != null) {
        ctx.dispatch(RecoverAccountActionCreator.refreshUI());
        ctx.dispatch(RecoverAccountActionCreator.qrLogin(result.message));
      }
    }
  } catch (e) {
    l.e("相册扫码失败：", "$e");
  }
}

///扫码登录
void _qrLogin(Action action, Context<RecoverAccountState> ctx) async {
  String qr = action.payload;
  if (TextUtil.isEmpty(qr)) {
    showToast(msg: Lang.INVALID_QR_CODE);
    return;
  }
  WBLoadingDialog.show(ctx.context);
  // 清除旧的token
  await netManager.setToken(null);
  // 生成新的ua
  await netManager.userAgent(await getDeviceId());
  UserInfoModel userInfo = await GlobalStore.loginByQr(qr);
  WBLoadingDialog.dismiss(ctx.context);

  if (null == userInfo) {
    showToast(msg: "登录失败，用户信息为空～");
    return;
  }
  showToast(msg: Lang.PHONE_LOGIN_SUCCESS);
  safePopPage();
  _handleLoginSuccess(action, ctx, userInfo, qr);
}

_handleLoginSuccess(Action action, Context<RecoverAccountState> ctx,
    UserInfoModel userInfo, String qrCode) async {}

void _dispose(Action action, Context<RecoverAccountState> ctx) async {
  WBLoadingDialog.dismiss(ctx.context);
}
