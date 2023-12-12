import 'dart:typed_data';
import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/account_qrcode/action.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'state.dart';

Effect<AccountQrCodeState> buildEffect() {
  return combineEffects(<Object, Effect<AccountQrCodeState>>{
    Lifecycle.initState: _initData,
    AccountQrCodeAction.onSaveQrCode: _saveQrImage
  });
}

///获取二维码数据
void _initData(Action action, Context<AccountQrCodeState> ctx) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    try {
      // eaglePage(ctx.state.selfId(),
      //     sourceId: ctx.state.eagleId(ctx.context));
      var orCodeModel = await netManager.client.getQrCodeInfo();
      String qrCodeStr = orCodeModel.content;
      ctx.dispatch(AccountQrCodeActionCreator.getQrCodeSuccess(qrCodeStr));
    } catch (e) {
      l.d('getQrCodeInfo===', e.toString());
      //showToast(msg: e.toString());
      return;
    }
  });
}

///保存二维码图片信息
void _saveQrImage(Action action, Context<AccountQrCodeState> ctx) async {
  Future.delayed(Duration(milliseconds: 20), () async {
    //  eagleClick(ctx.state.selfId(),
    //       sourceId: ctx.state.eagleId(ctx.context));
    RenderRepaintBoundary boundary =
        ctx.state.boundaryKey.currentContext.findRenderObject();
    Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    bool suc = await savePngDataToAblumn(pngBytes);
    if (suc) safePopPage();
  });
}
