import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_base/utils/brower_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    loufengState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        leading: GestureDetector(
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: Dimens.pt18),
            child: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          onTap: () async {

            /*bool canGoBack = await state.webView.canGoBack();

            if (canGoBack) {
              state.webView.goBack();
            }*/

          },
        ),
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          "娱乐",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Offstage(
            offstage: !state.isLoading,
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
            ),
          ),
          Opacity(
              opacity: state.isLoading ? 0.0 : 1.0,
              child: InAppWebView(
                initialUrl: VariableConfig.louFengH5,
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      debuggingEnabled: true,
                      javaScriptEnabled: true,
                      javaScriptCanOpenWindowsAutomatically: true,
                      useOnDownloadStart: true),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  state.webView = controller;
                },
                onLoadStart:
                    (InAppWebViewController controller, String url) async {

                  if (!state.isFirstLoad) {

                    await openBrowser(url).then((value) async {



                      //print("---------object--------");


                      /*Future.delayed(const Duration(milliseconds: 800),
                        () async {
                      bool canGoBack = await state.webView.canGoBack();
                      if (canGoBack) {
                        state.isFirstLoad = true;
                        await state.webView.goBack();
                      }
                    });*/


                    });

                  }
                },


                onLoadStop:
                    (InAppWebViewController controller, String url) async {
                  dispatch(loufengActionCreator.updateLoading());
                  state.isFirstLoad = false;
                },


                onProgressChanged:
                    (InAppWebViewController controller, int progress) {},
              ))
        ],
      ));
}
