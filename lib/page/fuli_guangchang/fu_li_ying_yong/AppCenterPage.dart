import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:getwidget/types/gf_progress_type.dart';

class AppCenterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AppCenterPageState();
  }

}

class _AppCenterPageState extends State<AppCenterPage> {

  InAppWebViewController webView;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          child: Column(children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    initialUrl: Address.appCenterUrl,
                    initialHeaders: {},
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: true,
                        )),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;

                    },
                    onLoadStart: (InAppWebViewController controller, String url) {
                      setState(() {

                      });
                    },
                    onLoadStop:
                        (InAppWebViewController controller, String url) async {
                      setState(() {

                      });
                    },
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },

                    /*onJsAlert: (controller,jsConfirmRequest){
                      //print(jsConfirmRequest.toString());
                    },*/
                    onLoadResource: ( controller,  re){
                      print(re.toString());
                    },
                    /*onAjaxProgress: ( controller,  ajaxRequest){
                      return print(re.toString());
                    },*/
                  ),
                  /*Visibility(
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
                            '拼命加载中...',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ])),
    );
  }

}