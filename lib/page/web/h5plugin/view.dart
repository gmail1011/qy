import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/page/web/h5plugin/action.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'state.dart';

Widget buildView(
    H5PluginState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Stack(
      children: <Widget>[
        WebviewScaffold(
          resizeToAvoidBottomInset: true,
          withJavascript: true,
          withZoom: true,
          withLocalStorage: true,
          javascriptChannels: [
            JavascriptChannel(
                name: 'open', //打开权限
                onMessageReceived: (JavascriptMessage message) {
                  dispatch(H5PluginActionCreator.onOpenPermission());
                }),
            JavascriptChannel(
                name: 'navToPage', //打开APP页面 或者 外部浏览器（打开并关闭当前页面）
                onMessageReceived: (JavascriptMessage message) {
                  JRouter().go(message.message, needPop: true);
                  // openAppUrl(viewService.context, message.message, isPop: true);
                }),
            JavascriptChannel(
                name: 'navToPageNoPop', //打开APP页面 或者 外部浏览器（打开并不关闭当前页面）
                onMessageReceived: (JavascriptMessage message) async {
                  state.flutterWebViewPlugin?.hide();
                  await JRouter().go(message.message, needPop: false);
                  // await openAppUrl(viewService.context, message.message,
                  //     isPop: false);
                  state.flutterWebViewPlugin?.show();
                }),
            JavascriptChannel(
                name: 'updateTitle', //更新TITLE
                onMessageReceived: (JavascriptMessage message) {
                  dispatch(H5PluginActionCreator.updateTitle(message.message));
                }),
            JavascriptChannel(
                name: 'back', //关闭当前页面
                onMessageReceived: (JavascriptMessage message) {
                  dispatch(H5PluginActionCreator.onBackAction());
                }),
            JavascriptChannel(
                name: 'savePhotoAlbum', //保存图片
                onMessageReceived: (JavascriptMessage message) {
                  dispatch(
                      H5PluginActionCreator.savePhotoAlbum(message.message));
                }),
            JavascriptChannel(
                name: 'openOnlinService', //打开在线客服
                onMessageReceived: (JavascriptMessage message) async {
                  state.flutterWebViewPlugin?.hide();
                  await csManager.openServices(viewService.context);
                  state.flutterWebViewPlugin?.show();
                }),
          ].toSet(),
          initialChild: Center(
            child: LoadingWidget(),
          ),
          url: state.url ?? '',
          appBar: AppBar(
            title: Text(state.title ?? ""),
            //文字title居中
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  dispatch(H5PluginActionCreator.onReturnAction());
                }),
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            width: Dimens.pt2,
            height: Dimens.pt780,
            color: Colors.transparent,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: Dimens.pt360,
            height: Dimens.pt2,
            color: Colors.transparent,
          ),
        ),
      ],
    ),
  );
}
