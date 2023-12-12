import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_app/widget/dialog/wx_dialog.dart';
import 'action.dart';
import 'state.dart';

Effect<PersonalCardState> buildEffect() {
  return combineEffects(<Object, Effect<PersonalCardState>>{
    PersonalCardAction.onSaveImage: _saveImage,
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<PersonalCardState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () {
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

///保存图片
_saveImage(Action action, Context<PersonalCardState> ctx) async {
  Future.delayed(Duration(milliseconds: 20), () async {
    RenderRepaintBoundary boundary =
        ctx.state.boundaryKey.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    bool suc = await savePngDataToAblumn(byteData.buffer.asUint8List());
    if (suc)
      showGoWXDialog(ctx.context,
          title: Lang.SAVE_PHOTO_ALBUM, subTitle: Lang.SAVE_PHOTO_DETAILS);
  });
}
