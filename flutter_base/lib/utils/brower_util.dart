import 'package:flutter_base/assets/base_lang.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';

/// 浏览器跳转
Future openBrowser(String url, {String tip = BaseLang.CANT_OPEN_URL}) async {
  try {
    //if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    //} else {
   //   showToast(msg: tip);
   // }
    return;
  } catch (e) {
    l.e("browser", "openBrowser()...error:$e");
  }
  showToast(msg: BaseLang.ERROR_OPEN_URL);
}

/// 从浏览器打开微信
openWxFromBrowser() async {
  String url = "weixin://";
  openBrowser(url, tip: BaseLang.INSTALL_TX);
}
