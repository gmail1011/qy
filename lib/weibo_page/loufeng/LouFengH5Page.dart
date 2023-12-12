import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_base/utils/brower_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LouFengH5Page extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LouFengH5PageState();
  }

}

class _LouFengH5PageState extends State<LouFengH5Page> with WidgetsBindingObserver,AutomaticKeepAliveClientMixin{


  InAppWebViewController webView;
  bool isLoading = true;
  bool isFirstLoad = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this); //添加观察者
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this); //销毁观察者
  }

  ///生命周期变化时回调
//  resumed:应用可见并可响应用户操作
//  inactive:用户可见，但不可响应用户操作
//  paused:已经暂停了，用户不可见、不可操作
//  suspending：应用被挂起，此状态IOS永远不会回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    super.didChangeAppLifecycleState(state);
    print("@@@@@@@@@  didChangeAppLifecycleState: $state");


    if(state == AppLifecycleState.resumed){

      bool canGoBack = await webView.canGoBack();

      if (canGoBack) {

        isFirstLoad = true;

        await webView.goBack();

      }
    }


  }

  ///当前系统改变了一些访问性活动的回调
  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    print("@@@@@@@@@ didChangeAccessibilityFeatures");
  }

  /// Called when the system is running low on memory.
  ///低内存回调
  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    print("@@@@@@@@@ didHaveMemoryPressure");
  }

  /// Called when the system tells the app that the user's locale has
  /// changed. For example, if the user changes the system language
  /// settings.
  ///用户本地设置变化时调用，如系统语言改变
  @override
  void didChangeLocales(List<Locale> locale) {
    super.didChangeLocales(locale);
    print("@@@@@@@@@ didChangeLocales");
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  ///应用尺寸改变时回调，例如旋转
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    Size size = WidgetsBinding.instance.window.physicalSize;
    print("@@@@@@@@@ didChangeMetrics  ：宽：${size.width} 高：${size.height}");
  }

  /// {@macro on_platform_brightness_change}
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    print("@@@@@@@@@ didChangePlatformBrightness");
  }

  ///文字系数变化
  @override
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
    print(
        "@@@@@@@@@ didChangeTextScaleFactor  ：${WidgetsBinding.instance.window.textScaleFactor}");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Scaffold(
        /*appBar: AppBar(
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

              bool canGoBack = await state.webView.canGoBack();

            if (canGoBack) {
              state.webView.goBack();
            }

            },
          ),
          titleSpacing: 0,
          centerTitle: true,
          title: Text(
            "娱乐",
            style: TextStyle(color: Colors.white),
          ),
        ),*/
        body: Stack(
          children: [
            Offstage(
              offstage: !isLoading,
              child: Container(
                color: Colors.black,
                alignment: Alignment.center,
              ),
            ),
            Opacity(
                opacity: isLoading ? 0.0 : 1.0,
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
                    webView = controller;
                  },
                  onLoadStart:
                      (InAppWebViewController controller, String url) async {

                    if (!isFirstLoad) {

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
                        isLoading = false;
                    isFirstLoad = false;

                    setState(() {

                    });

                  },


                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {},
                ))
          ],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}