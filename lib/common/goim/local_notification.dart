import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/goim/goim_client.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/token_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

Future<void> initLocalNotification() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
    didReceiveLocalNotificationSubject.add(ReceivedNotification(
        id: id, title: title, body: body, payload: payload));
  });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    var hourTimes = [19, 20, 21, 22];
    var time = Time(hourTimes[Random().nextInt(hourTimes.length)], 0, 0);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(badgeNumber: 1);
    var platformChannelSpecifics =
        NotificationDetails(null, iOSPlatformChannelSpecifics);
    var index = Random().nextInt(Lang.NOTIFICATION_TITLES.length);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        Lang.NOTIFICATION_TITLES[index],
        Lang.NOTIFICATION_CONTENTS[index],
        time,
        platformChannelSpecifics);
  }
}

// 执行通知
Future<void> showNotification(
    {String title, String body, String payload = ""}) async {
//  //---------假数据 ----------------
//  String jsonStr = "{\"title\":\"uid-测试一下消息发送 \",\"msgType\":\"CHARGE\",\"data\":\"您已经到账100元\"}";
//  Map<String, dynamic> user = jsonDecode(jsonStr);
//  title = user["title"];
//  body = user["data"];
//  //---------假数据 ----------------
  if (title == null || title.isEmpty || body == null || body.isEmpty) {
    return;
  }
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      icon: "@mipmap/ic_round_launcher",
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: payload);
}

//=================================链接=================================

class LocalNtf {
  static GoIMClient iMClient;

  // static VoidCallback walletChanage;
  // static StreamController<String> notify = StreamController.broadcast();
  // static void sendNotify(String event) {
  //   notify.add(event);
  // }

  static void ntfLog(String str) {
    l.d("oldLog", "【IM-notifiction】:------ " + str);
  }

  // 启动准备完成后 调用
  static devLoginBackCall() {
    getOnlineCustomServiceUrl(
        GlobalStore.store?.getState()?.meInfo?.uid?.toString() ?? "0");
  }

  // 链接IM服务器
  static void getOnlineCustomServiceUrl(String userId) async {
    ntfLog("userId = $userId");
    if (userId == null || userId.isEmpty) return;
    // 获取 IM token
    String imToken = "";
    // Map<String, dynamic> paramGetToken = {
    //   "mid": userId, //用户ID
    //   "appId": "20201159527",
    //   "sign": _encrypt("20201159527音色视频"),
    // };
    // BaseResponse response = await getOnlineCustomerImToken(paramGetToken);
    try {
      String sign = _encrypt("20201159527音色视频");
      TokenModel tokenModel = await netManager.client
          .getOnlineCustomerImToken(userId, "20201159527", sign);
      imToken = tokenModel.token;
      l.d("oldLog", "imToken : $imToken");

      /// 链接
      Map<String, dynamic> paramLink = {
        "appId": "20201159527",
        "sign": imToken,
      };
      iMClient = GoIMClient(Config.IM_NTF_ROUTE, authBuilder: () {
        return paramLink;
      }, messageHandler: (Uint8List msg) {
        String jsonStr =
            Utf8Decoder().convert(String.fromCharCodes(msg).codeUnits);
        Map<String, dynamic> user = jsonDecode(jsonStr);
        ntfLog("jsonStr : $jsonStr");
        // 调用通知
        String title = user["title"];
        String body = user["data"];
        String msgType = user["msgType"];
        switch (msgType) {
          case "CHARGE": //充值信息
            GlobalStore.refreshWallet();
            Future.delayed(Duration(seconds: 30), () {
              GlobalStore.updateUserInfo(null);
            });
            // sendNotify(msgType);
            break;
          case "WITHDRAW": //提现信息
            break;
          case "VIDCHECK": //视频审核信息
          case "VIP-CHARGE":
            GlobalStore.updateUserInfo(null);
            break;
          default:
            break;
        }
        showNotification(title: title, body: body);
      });
      iMClient.createConnect();
    } catch (e) {
      // ntfLog(
      //     "paramGetToken = $paramGetToken,  response.code = ${response.code}");
    }
//     if (response == null ||
//         response.code != Code.SUCCESS ||
//         response.data == null) {
//       ntfLog(
//           "paramGetToken = $paramGetToken,  response.code = ${response.code}");
//       return;
//     }
//     imToken = response.data["token"];
//     l.d("oldLog", "imToken : $imToken");

//     /// 链接
//     Map<String, dynamic> paramLink = {
//       "appId": "20201159527",
//       "sign": imToken,
//     };
//     iMClient = GoIMClient(Config.IM_NTF_ROUTE, authBuilder: () {
//       return paramLink;
//     }, messageHandler: (Uint8List msg) {
//       String jsonStr =
//           Utf8Decoder().convert(String.fromCharCodes(msg).codeUnits);
// //      String jsonStr = "{\"title\":\"uid-测试一下消息发送 \",\"msgType\":\"CHARGE\",\"data\":\"您已经到账100元\"}";
//       //先转json
// //      var json = jsonDecode(jsonStr);
//       Map<String, dynamic> user = jsonDecode(jsonStr);
//       ntfLog("jsonStr : $jsonStr");
//       // 调用通知
//       String title = user["title"];
//       String body = user["data"];
//       String msgType = user["msgType"];
//       switch (msgType) {
//         case "CHARGE": //充值信息
//           GlobalStore.refreshWallet();
//           Future.delayed(Duration(seconds: 30), () {
//             GlobalStore.updateUserInfo(null);
//           });
//           // sendNotify(msgType);
//           break;
//         case "WITHDRAW": //提现信息
//           break;
//         case "VIDCHECK": //视频审核信息
//         case "VIP-CHARGE":
//           GlobalStore.updateUserInfo(null);
//           break;
//         default:
//           break;
//       }
//       showNotification(title: title, body: body);
//     });
//     iMClient.createConnect();
//     return null;
  }

  static test() {
    String jsonStr =
        "{\"title\":\"uid-测试一下消息发送 \",\"msgType\":\"CHARGE\",\"data\":\"您已经到账100元\"}";
    // 先转json
    // var json = jsonDecode(jsonStr);
    Map<String, dynamic> user = jsonDecode(jsonStr);
    ntfLog("jsonStr : $jsonStr");
    print(
        "-----------------------------------------Notification jsonStr : $jsonStr");
    // 调用通知
    String title = user["title"];
    String body = user["data"];
    // sendNotify("msgType");
    // getWallet().then((res) {
    //   if (res.code == 200) {
    //     WalletModelEntity entity = WalletModelEntity.fromJson(res.data);
    //     entity.income = 1100;
    //     if (entity != null) {
    //       VariableConfig.walletEntity = entity;
    //     }
    //   }
    // });

    showNotification(title: title, body: body);
  }

  // 加密
  static String _encrypt(String plainText) {
    if (plainText == null || plainText.isEmpty) return '';
    var key = utf8.encode(Config.IM_ENCRYPT_KEY);
    var bytes = utf8.encode(plainText);
    var sha256Encrypt = new Hmac(sha256, key);
    var digest = sha256Encrypt.convert(bytes);
    return digest.toString();
  }
}
