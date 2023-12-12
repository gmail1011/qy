import 'dart:io';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/decrypt_image.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'action.dart';
import 'state.dart';

Effect<H5PluginState> buildEffect() {
  return combineEffects(<Object, Effect<H5PluginState>>{
    Lifecycle.initState: _initState,
    H5PluginAction.onOpenPermission: _onOpenPermission,
    H5PluginAction.returnAction: _returnAction,
    H5PluginAction.backAction: _backAction,
    H5PluginAction.savePhotoAlbum: _savePhotoAlbum,
    Lifecycle.dispose: _dispose,
  });
}

void _initState(Action action, Context<H5PluginState> ctx) {
  ctx.state.flutterWebViewPlugin?.onBack?.listen((_) {
    ctx.state.flutterWebViewPlugin.evalJavascript("closeWS()");
  });
  Future.delayed(Duration(milliseconds: 200), () {
   // eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

void _backAction(Action action, Context<H5PluginState> ctx) async {
  safePopPage();
}

/// 保存图片到相册
void _savePhotoAlbum(Action action, Context<H5PluginState> ctx) async {
  var url = action.payload as String;
  if (TextUtil.isEmpty(url) || !url.startsWith("http")) {
    showToast(msg: Lang.DOWNLOAD_URL_ERROR);
    return;
  }
  http.Response response = await http.get(url);
  http.Response newResponse = http.Response.bytes(
      decryptImage(response.bodyBytes), response.statusCode);
  if (newResponse.statusCode == 200 || newResponse.statusCode == 201) {
    await savePngDataToAblumn(newResponse.bodyBytes);
  } else {
    showToast(msg: Lang.DOWNLOAD_FAILED);
  }
}

void _returnAction(Action action, Context<H5PluginState> ctx) async {
  await ctx.state.flutterWebViewPlugin?.evalJavascript("closeWS()");
  if (await ctx.state.flutterWebViewPlugin?.canGoBack()) {
    ctx.state.flutterWebViewPlugin?.goBack();
  } else {
    ctx.state.flutterWebViewPlugin?.close();
    safePopPage();
  }
}

///开启权限
void _onOpenPermission(Action action, Context<H5PluginState> ctx) async {
  if (Platform.isAndroid) {
    try {
      if (await Permission.camera.request().isGranted) {
        showToast(msg: Lang.NO_AUTHORITY_TO_USE_CAMERA);
      }
    } catch (e) {
      showToast(msg: Lang.GET_PERMISSION_ERROR);
    }
  }
}

///开启权限
void _dispose(Action action, Context<H5PluginState> ctx) async {
  ctx.state.flutterWebViewPlugin?.close();
  ctx.state.flutterWebViewPlugin?.dispose();
}
