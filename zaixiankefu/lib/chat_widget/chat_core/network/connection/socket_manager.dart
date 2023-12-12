import 'dart:convert';

import 'package:chat_online_customers/chat_widget/chat_core/network/connection/msg_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_model/userModel.dart';
import 'package:chat_online_customers/chat_widget/chat_page/page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocketManager {
  // 单例公开访问点
  factory SocketManager() => _sharedInstance();

  // 静态私有成员，没有初始化
  static SocketManager _instance;

  // 私有构造函数
  SocketManager._() {
    // 具体初始化代码
  }

  // 静态、同步、私有访问点
  static SocketManager _sharedInstance() {
    if (_instance == null) {
      _instance = SocketManager._();
    }
    return _instance;
  }

  KefuUserModel model;

  ValueChanged<int> getMsg;

  String get connectUrl {
    String url = SocketManager().model.connectUrl;
    String version = "&version=3.0.0";
    if (url.contains('http://')) {
      url = url.replaceAll('http://', 'ws://');
    }
    if (url.contains('https://')) {
      url = url.replaceAll('https://', 'wss://');
    }
    return url + version;
  }

  String get appId {
    String connectUrl = SocketManager().model.connectUrl;
    var currentAppId;
    if (connectUrl.contains('appId')) {
      String s = connectUrl.split('appId=').last;
      currentAppId = s.split('&').first;
    }
    return currentAppId;
  }

  Future jumpToChatWidget(BuildContext context) {
    return Navigator.push(
      context,
      new MaterialPageRoute(builder: (BuildContext context) {
        return ChatPage().buildPage(model);
      }),
    );
  }

  Future requestIsConnect() async {
    await MsgUtils.judgeIsConnect(model);
  }

  ///处理当前文本内容
  List<String> getUrl(String text) {
    String currentText = '答：' + text;
    List<String> stringList = List();
    List<String> list = currentText.split('<a>');
    for (String str in list) {
      if (str.contains('http')) {
        for (String s in str.split('</a>')) {
          stringList.add(s.isNotEmpty ? s : '');
        }
      } else {
        stringList.add(str.isNotEmpty ? str : '');
      }
    }
    return stringList;
  }

  ///处理带有http链接的文本消息
  List<String> dealText(String text) {
    List<String> stringList = List();
    List<String> list = text.split('\n');
    for (String d in list) {
      for (String k in d.split(' ')) {
        if (k.contains('http')) {
          var t = k.split('http').first;
          var b = 'http' + k.split('http').last;
          if (t.length > 0) {
            stringList.add(t ?? '');
          }
          stringList.add(b ?? '');
        } else {
          stringList.add(k ?? '');
        }
      }
    }
    return stringList;
  }

  ///跳转到浏览器
  launchURL(String url) async {
    try {
      List<int> bytes = url.codeUnits;
      String u = utf8.decode(bytes);
      await launch(u);
    } catch (e) {}
  }
}
