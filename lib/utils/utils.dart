import 'dart:io';
import 'dart:typed_data';

import 'package:common_utils/common_utils.dart' hide TextUtil;
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/new_page/recharge/recharge_gold_page.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

///获取设备id
Future<String> getDeviceId() async {

  String deviceStr;
  try {

    const platform = const MethodChannel("com.yinse/device");

    deviceStr = await platform.invokeMethod("getDeviceId");

  } on PlatformException {

    deviceStr = "";

  }

  return "51ll"+deviceStr;

}

/// 获取个性化数量显示
String getShowCountStr(int number, {int count = 1}) {
  number = number ?? 0;
  String numStr = "";
  if (number > 100000000) {
    num _num = number / 100000000;
    _num = num.parse(_num.toStringAsFixed(count));

    numStr = _num.toString() + Lang.BILLION;
  } else if (number > 10000) {
    num _num = number / 10000;
    _num = num.parse(_num.toStringAsFixed(1));
    numStr = _num.toString() + "w";
  } else {
    numStr = number.toString();
  }
  return numStr;
}

///获取渠道
Future<String> getChannel() async {
  String channel = "";
  if (Platform.isAndroid) {
    const platform = const MethodChannel("com.yinse/device");
    try {
      channel = await platform.invokeMethod("getChannel");
    } on PlatformException {
      // channel = "1";
    }
  }
  return channel;
}

AssetImage getLocImage(String path, {AssetBundle bundle, String package}) {
  return AssetImage(path, bundle: bundle, package: package);
}

String numCoverStr(int num) {
  if (num == null) {
    return "0";
  }
  String followNum;
  if (num >= 10000) {
    String unit = "w";
    double newNum = num / 10000.0;

    followNum = newNum.toStringAsFixed(2) + unit;
  } else {
    followNum = num.toString();
  }
  return followNum;
}

// [转发自用户 南宫凰]
// 1、刚刚
// 1、多少分钟
// 2、几小时内
// 3、超过2小时就不显示时间了
String showDateDesc(String time) {
  if (time == null) return "刚刚";
  if (time.length <= 0) return "刚刚";
  var curSeconds = DateTime.now().millisecondsSinceEpoch / 1000;
  var oldSeconds = DateTime.parse(time).millisecondsSinceEpoch / 1000;
  var diff = curSeconds - oldSeconds;
  if (diff < 60) return "刚刚";
  if (diff < 3600) return "${diff ~/ 60}分钟";
  if (diff < 3600 * 2) return "${diff ~/ 3600}小时内";
  // var showTime = min(diff ~/ 86400, 3);
  // return "$showTime天前";
  
  
  return DateUtil.formatDateStr(time,isUtc: true,format: "yyyy-MM-dd HH:mm:ss",);
}

///影片时长 转换格式
String showPayTimeDesc(int payTime) {
  if (payTime <= 0) return "00:00:00";
  int h = payTime ~/ 3600;
  int m = payTime % 3600 ~/ 60;
  int s = payTime % 60;
  String result = (h == 0 ? "" : h.toString().padLeft(2, '0') + ":") +
      m.toString().padLeft(2, '0') +
      ":" +
      s.toString().padLeft(2, '0');
  return result;
}

///浏览器跳转
launchUrl(String url, {String tip}) async {


  await launch(url, forceSafariVC: false, forceWebView: false);

  /*try {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      if (tip != null && tip.isNotEmpty) {
        showToast(msg: tip);
      }
    }
  } catch (e) {}*/
}

///安装android和ios的app
installApp(String filePath) async {
  //判断权限是否已有
  if (await Permission.storage.request().isGranted) {
    DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    deviceInfoPlugin.androidInfo.then((androidInfo) {
      InstallPlugin.installApk(filePath, androidInfo.id);
    });
  }
}

///剪切字符串
///汉字长度2 其他字符长度1
String getNameMaxLength(String str, {int maxLength}) {
  int defaultLength = 13;
  var strList = str.split('');
  var strListLength = 0;
  for (var index = 0; index < strList.length; index++) {
    //判断是否是文字
    if (RegExp('[\u4e00-\u9fa5]').hasMatch(strList[index])) {
      strListLength = strListLength + 2;
    } else {
      strListLength = strListLength + 1;
    }
  }
  //是否有指定裁剪长度
  if (maxLength != null && maxLength < strListLength) {
    return str.substring(0, (maxLength ~/ 2)) + '...';
  } else {
    //判断是否满足裁剪条件
    if (strListLength >= defaultLength * 2) {
      return str.substring(0, defaultLength) + '...';
    } else {
      return str;
    }
  }
}

/// 服务器时间转
/// 2020-04-28T10:35:01.302Z to 2020-04-28 10:35:01
String serversTimeToString(String serverTime,
    {String format = 'yyyy-MM-dd HH:mm'}) {
  if (TextUtil.isEmpty(serverTime)) {
    return '';
  }
  return DateUtil.formatDateStr(serverTime ?? '', isUtc: false, format: format);
}

Future<String> getDevType() async {
  String devType = "";
  try {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      devType = "${androidInfo.device}:${androidInfo.version.sdkInt}";
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;
      devType = "${iosInfo.systemName}:${iosInfo.systemVersion}";
    }
  } catch (e) {
    l.e("devtype", "getDevType()...error:$e");
  }
  return devType;
}

///显示时间 [time] 秒 --->时间转换，例如：90  ->   01:30
String timePrint(double time) {
  double minute = 0;
  if (time >= 60) {
    minute = time / 60;
  }
  int second = time.toInt() % 60;
  var minute2 = minute.toInt();
  var str1 = (minute2 >= 10) ? minute2.toString() : "0${minute2.toString()}";
  var str2 = (second >= 10) ? second.toString() : "0${second.toString()}";
  return sprintf("%s:%s", [str1, str2]);
}

/// 显示规则：刚刚、几分钟前、几小时前、几天前、一周前、年月日
String formatTime(String _utcTime) {
  if(_utcTime == null) {
    return "";
  }
  var now = DateTime.now();
  var date = DateTime.parse(_utcTime);
  int changeTime =
      (now.millisecondsSinceEpoch - date.millisecondsSinceEpoch) ~/ 1000; //秒

  final int s = changeTime;
  if (s >= 0 && s < 60) {
    return "刚刚";
  }
  final int m = s ~/ 60;
  if (m > 0 && m < 60) {
    return "$m分钟前";
  }
  final int h = m ~/ 60;
  if (h > 0 && h < 24) {
    return "$h小时前";
  }
  final int d = h ~/ 24;
  if (d > 0 && d < 7) {
    return "$d天前";
  }

  final int w = d ~/ 7;
  if (w > 0 && w < 4) {
    return "$w周前";
  }

  final int month = d ~/ 30;
  if (month > 0) {
    // 显示 年月日
    String timeNow = DateUtil.formatDate(date,
        format: DateFormats.zh_y_mo_d); //2018年09月16日 23时16分15秒
    return timeNow;
  }
  return "";
}

String formatTimeTwo(String _utcTime, {String formats, bool isLocal = true}) {
  if(_utcTime == null) {
    return "";
  }
  var now = DateTime.now();
  DateTime date;
  if(isLocal == true){
    date = DateTime.parse(_utcTime).toLocal();
  }else {
    String timeDesc = _utcTime.replaceAll("T", " ");
    timeDesc = _utcTime.replaceAll("Z", "");
    date = DateTime.parse(timeDesc);
  }
  int changeTime =
      (now.millisecondsSinceEpoch - date.millisecondsSinceEpoch) ~/ 1000; //秒

  final int s = changeTime;
  if (s >= 0 && s < 60) {
    return "刚刚";
  }
  final int m = s ~/ 60;
  if (m > 0 && m < 60) {
    return "$m分钟前";
  }
  final int h = m ~/ 60;
  if (h > 0 && h < 24) {
    return "$h小时前";
  }
  final int d = h ~/ 24;
  if (d > 0 && d < 7) {
    return "$d天前";
  }

  final int w = d ~/ 7;
  if (w > 0 && w < 4) {
    return "$w周前";
  }

  final int month = d ~/ 30;
  if (month > 0 && month < 12) {
    return "$month个月前";
  }
  final int year = month ~/ 12;
  if (year > 0 && year < 12) {
    return "$year年前";
  }
  return DateUtil.formatDate(date, format: formats ?? DateFormats.y_mo_d);
}

String formatTimeThree(String _utcTime) {
  if(_utcTime == null) {
    return "";
  }
  var now = DateTime.now();
  var date = DateTime.parse(_utcTime).toLocal();
  int changeTime =
      (now.millisecondsSinceEpoch - date.millisecondsSinceEpoch) ~/ 1000; //秒

  final int s = changeTime;
  if (s >= 0 && s < 60) {
    return "刚刚";
  }
  final int m = s ~/ 60;
  if (m > 0 && m < 60) {
    return "$m分钟前";
  }
  final int h = m ~/ 60;
  if (h > 0 && h < 24) {
    return "$h小时前";
  }
  final int d = h ~/ 24;
  if (d > 0 && d < 7) {
    return "$d天前";
  }
  return DateUtil.formatDate(date, format: DateFormats.y_mo_d_h_m);
}


/// 保存数据到相册
Future<bool> savePngDataToAblumn(Uint8List pngBytes) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.photos,
    Permission.storage,
  ].request();

  if (!statuses[Permission.photos].isGranted ||
      !statuses[Permission.photos].isGranted) {
    showToast(msg: "请检查权限是否开启");
    return false;
  }

  var map = await ImageGallerySaver.saveImage(pngBytes);
  if (null != map && map["isSuccess"] == true) {
    // showToast(msg: "保存成功：$result");
    // await showConfirm(FlutterBase.appContext,
    //     content: "保存成功：${map["filePath"]}");
    showToast(msg: "保存成功");
    lightKV.setBool(Config.HAVE_SAVE_QR_CODE, true);
    return true;
  } else {
    showToast(msg: "保存失败，请手动截图");
    return false;
  }
}

/// 显示规则：刚刚、几分钟前、几小时前、几天前、一周前、年月日
String formatTimeForQuestion(String _utcTime) {
  try {
    var now = DateTime.now();
    var date = DateTime.parse(_utcTime);
    int changeTime =
        (now.millisecondsSinceEpoch - date.millisecondsSinceEpoch) ~/ 1000; //秒

    final int s = changeTime;
    if (s >= 0 && s < 60) {
      return "刚刚";
    }
    final int m = s ~/ 60;
    if (m > 0 && m < 60) {
      return "$m分钟前";
    }
    final int h = m ~/ 60;
    if (h > 0 && h < 24) {
      return "$h小时前";
    }
    final int d = h ~/ 24;
    if (d > 0 && d < 7) {
      return "$d天前";
    }

    final int w = d ~/ 7;
    if (w > 0 && w < 4) {
      return "$w周前";
    }

    final int month = d ~/ 30;
    if (month > 0) {
      // 显示 年月日
      String timeNow =
          DateUtil.formatDate(date, format: DateFormats.mo_d); //MM-dd
      return timeNow;
    }
  } catch (e) {}
  return "";
}

/// 获取个性化数量显示
String getShowFansCountStr(int number, {int count = 1}) {
  number = number ?? 0;
  String numStr = "";
  if (number > 100000000) {
    num _num = number / 100000000;
    _num = num.parse(_num.toStringAsFixed(count));

    numStr = _num.toString() + "亿";
  } else if (number > 10000) {
    num _num = number / 10000;
    _num = num.parse(_num.toStringAsFixed(1));
    numStr = _num.toString() + "w";
  } else if (number > 1000) {
    num _num = number / 1000;
    _num = num.parse(_num.toStringAsFixed(1));
    numStr = _num.toString() + "k";
  } else {
    numStr = number.toString();
  }
  return numStr;
}


Future pushToPage(Widget page, {BuildContext context,  bool opaque = false}) async{
  return Navigator.push(context ?? FlutterBase.appContext,
      MaterialPageRoute(builder: (context) {
        return page;
      }));
}

///购买作品
Future<bool> buyProduct(BuildContext context,String productID,String name,int amount) async {
  try {

    WBLoadingDialog.show(context);
    var result =
    await netManager.client.postBuyVideo(productID, name, amount, 1);
    l.e("购买视频返回数据", "$result");
    WBLoadingDialog.dismiss(context);
    GlobalStore.updateUserInfo(null);
    return Future.value(true);
  } catch (e) {
    WBLoadingDialog.dismiss(context);
    var error = e.error;
    if (error is ApiException) {
      if (error.code == 8000) {
        ///进入会员中心充值金币
        Config.payFromType = PayFormType.video;
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return RechargeGoldPage();
        }));
      }
    } else {
      showToast(msg: e.toString());
    }
    l.d('productBuy', e.toString());
    return Future.value(false);
  }
}
