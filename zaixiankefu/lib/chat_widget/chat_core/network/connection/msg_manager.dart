/*
 * @Author: your name
 * @Date: 2020-05-29 21:03:22
 * @LastEditTime: 2020-06-01 17:28:26
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /zaixiankefu/lib/chat_widget/chat_core/network/connection/msgManager.dart
 */
import 'dart:async';
import 'dart:io';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/connect_util.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/dio_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_model/userModel.dart';
import 'package:chat_online_customers/chat_widget/chat_page/utils/util.dart';
import 'package:chat_online_customers/chat_widget/utils/logger.dart';
import '../utils/util.dart';
import '../../packets.dart';

/**
 * CONNECTING    正在尝试连接服务器
 * CONNECTED    已成功连接服务器
 * CLOSING      正在断开服务器连接
 * CLOSED       已断开与服务器连接
 * ERROR        与服务器连接发生错误
 */
enum SocketStateEnum { CONNECTING, CONNECTED, CLOSING, CLOSED, ERROR }

var _connectTimer;

class MsgUtils {
  static WebSocket _webSocket;
  static num _id = 0;
  static Future<WebSocket> futureWebSocket;
  static SocketStateEnum socketSate = SocketStateEnum.CLOSED;

  static Future judgeIsConnect(KefuUserModel model) async {
    String connectUrl = model.connectUrl;
    var currentAppId;
    if (connectUrl.contains('appId')) {
      String s = connectUrl.split('appId=').last;
      currentAppId = s.split('&').first;
    }
    // api/play/unread
    Map<String, String> map = Map();
    map['appId'] = currentAppId ?? '';
    map['userId'] = model.userId ?? '';
    DioUtils.requestHttp(SocketManager().model.checkConnectApi,
        parameters: map, method: DioUtils.POST, onSuccess: (data) {
      print(data);
      if (data != null && data is Map) {
        if (data['data'] == false) {
          Instance.isConnect = false;
        } else {
          //  MsgUtils.con(DateTime.now().millisecondsSinceEpoch);
          Instance.isShut = true;
          Instance.isConnect = true;
          // MsgUtils.longConnection(SocketManager().model.connectUrl, getdata);
          int nowDate = DateTime.now().millisecondsSinceEpoch;
          MsgUtils.newConnect(SocketManager().connectUrl, nowDate);
          MsgUtils.longConnection(SocketManager().connectUrl, getdata);
        }
      } else {
        Instance.isConnect = false;
        socketSate = SocketStateEnum.CLOSED;
      }
    });
  }

  //不是办法的办法
  static void newConnect(String connectUrl, int startDate) {
    socketSate = SocketStateEnum.CONNECTING;
    // Api.WS_URL 为服务器端的 websocket 服务
    futureWebSocket = WebSocket.connect(connectUrl);
    futureWebSocket.then((WebSocket ws) {
      _webSocket = ws;
      MsgUtils.sendMsgToRequestLastTimeData();
    });
  }

  static void closeSocket() {
    socketSate = SocketStateEnum.CLOSING;
    _webSocket.close();
  }

  static SocketStateEnum state() {
    return socketSate;
  }

  static Future longConnection(String url, Function cb) async {
    // 打开数据链接
    // 开始连接的时间（转为时间戳）
    var nowDate = DateTime.now().millisecondsSinceEpoch;
    await MsgUtils.connect(url, (dynamic context) {
      var baseMessage = BaseMessage.fromBuffer(context);
      // 当前action
      var action = baseMessage.action;
      // 解码数据
      var data = obtainData(action, baseMessage.data);
      if (action == 2003 && Instance.isCallBack == false) {
        Instance.count++;
        // ChatColor.getMsg(Instance.count);
        SocketManager().getMsg?.call(Instance.count);
      }
      if (action == 4003 || action == 2009 || action == 2000) {
        Instance.isConnect = false;
        _connectTimer?.cancel();
        _connectTimer = null;
      } else {
        Instance.isConnect = true;
        _connectTimer?.cancel();
        _connectTimer = null;
        _connectTimer = Timer(Duration(seconds: 35), () {
          longConnection(url, cb);
        });
      }
      cb(action, data);
    }, nowDate);
  }

  // 向服务器发送消息
  static void sendMessage(dynamic content) {
    _webSocket?.add(content);
  }

  static Future connect(
      String connectUrl, Function callback, int startDate) async {
    try {
      // Api.WS_URL 为服务器端的 websocket 服务
      socketSate = SocketStateEnum.CONNECTING;
      _webSocket = await WebSocket.connect(connectUrl);
      int readyState = _webSocket.readyState;
      if (readyState != 1 && readyState != 0) {
        socketSate = SocketStateEnum.CLOSED;
        Instance.isConnect = false;
        // 获取现在时间
        int nowDate = DateTime.now().millisecondsSinceEpoch;
        // 如果连接不成功这10秒内再次连接
        if (nowDate - startDate <= 10000)
          await connect(connectUrl, callback, startDate);
      } else {
        Instance.isConnect = true;
        socketSate = SocketStateEnum.CONNECTED;
        _webSocket.listen(callback, onError: (a) {
          socketSate = SocketStateEnum.ERROR;
        }, onDone: () {});
      }
    } catch (e) {
      // Instance.isConnect = false;
      socketSate = SocketStateEnum.CLOSED;
    }
  }

  static void sendMsgToRequestLastTimeData() async {
    CurrentSessionMessage currentSessionMessage =
        CurrentSessionMessage.create();
    currentSessionMessage.platId = await obtainValueByKey('platId') ?? '';
    currentSessionMessage.userId = await obtainValueByKey('id') ?? '';
    currentSessionMessage.currentSessionId =
        await obtainValueByKey('sessionId') ?? '';
    BaseMessage baseMessage = BaseMessage.create();
    baseMessage.action = 1005;
    baseMessage.data = currentSessionMessage.writeToBuffer();
    MsgUtils.sendMessage(baseMessage.writeToBuffer());
  }
}

void getdata(var action, dynamic data) {
  if (action == 2005) {
    ChatUserList chatUserList = data;
    if (chatUserList.list.length > 0) {
      ChatUserInfo info = chatUserList.list[0];
      for (var i = 0; i < info.msgs.length; i++) {
        ChatFields chatFields = info.msgs[i];
        if (chatFields.type != 1 && chatFields.isRead == 1) {
          Instance.count++;
        }
      }
    }
    SocketManager().getMsg(Instance.count);
  }
}
