import 'dart:async';
import 'dart:io';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:getwidget/types/gf_progress_type.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameSurfacePage extends StatefulWidget {
  String gameUrl;

  GameSurfacePage(this.gameUrl);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GameSurfacePageState();
  }
}

class _GameSurfacePageState extends State<GameSurfacePage> {
  String selectedUrl = '';

  WebViewController webViewController;

  InAppWebViewController webView;
  String url = "";
  double progress = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AutoOrientation.landscapeAutoMode();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // AutoOrientation.portraitAutoMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  initialUrl: widget.gameUrl,
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: true,
                  )),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                    Config.webView = controller;
                  },
                  onLoadStart: (InAppWebViewController controller, String url) {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onLoadStop:
                      (InAppWebViewController controller, String url) async {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                ),
                Visibility(
                  visible: progress < 1.0 ? true : false,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GFProgressBar(
                          percentage: progress,
                          padding: EdgeInsets.only(left: 140,right: 140),
                          backgroundColor: Colors.black26,
                          progressBarColor: GFColors.DANGER,
                          animateFromLastPercentage: true,
                          lineHeight: 14,
                          type: GFProgressType.linear,
                          alignment: MainAxisAlignment.center,
                          child: Text(
                            (progress * 100).toStringAsFixed(0) + '%',
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 16,),
                        Text(
                          '游戏拼命加载中...',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ])),
      ),
    );
  }
}
