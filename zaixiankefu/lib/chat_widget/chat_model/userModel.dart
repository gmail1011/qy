/*
 * @Author: your name
 * @Date: 2020-05-22 19:45:09
 * @LastEditTime: 2020-06-06 16:04:26
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /zaixiankefu/lib/chat_widget/chat_model/userModel.dart
 */

import 'package:flutter/material.dart';

class KefuUserModel {
  ///用户昵称
  ///ceshi11111111
  String username;

  ///app启动时必须传  如果从在线客服入口进入可以不传 用户ID
  String userId;

  ///当前平台请求api的域名

  String baseUrl;

  ///webSocket链接地址 地址格式 当前域名 + customer/im? + 签名数据

  String connectUrl;

  ///用户头像 加密就穿base64  未加密直接传url
  String avatar;

  ///faq 数据接口
  String faqApi;

  ///faq 官方助手头像----svg图片
  String faqHeadImgPath;

  ///检测在线客服是否处于连接状态的接口地址
  String checkConnectApi;

  ///字体基础颜色
  Color baseColor;

  ///FAQ 问题分类颜色
  // Color classItemColor;

  ///各个问题的字体颜色
  Color questionColor;

  ///已解决 未解决 其他疑问 字体颜色
  // Color faqBtnColor;

  ///已解决 未解决 其他疑问 背景颜色颜色
  Color faqBtnBackgroundColor;

  ///发送按钮的字体颜色
  // Color sendBtnColor;

  ///客服对话框背景颜色
  Color customerBackGroundColor;

  ///用户对话框背景颜色
  Color userBackGroundColor;

  ///是否使用语音  默认false 不实用  true使用
  bool isVoice;

  ///选择照片上传的按钮颜色
  // Color selectPicColor;

  // ///已读状态 颜色
  // Color alreadyReadColor;

//突出顏色
  Color primaryColor;

  ///未读状态颜色
  Color unReadColor;

  ///
  ///提示文字颜色
  Color tipColor;

  ///昵称的字体颜色
  Color nicknameColor;

  ///背景色
  Color backgroundColor;
  ThemeData themeData;
  Color appBarColor;

  KefuUserModel({
    @required this.username,
    @required this.baseUrl,
    @required this.connectUrl,
    @required this.faqHeadImgPath,
    @required this.checkConnectApi,
    this.isVoice = false,
    this.userId = '',
    this.faqApi = '',
    this.avatar = '',
    this.themeData,
    this.nicknameColor = Colors.black,
    this.faqBtnBackgroundColor = const Color(0xFFEAEAEA),
    this.baseColor = Colors.black,
    this.primaryColor = Colors.blue,
    // this.classItemColor = Colors.blue,
    this.questionColor = Colors.black,
    // this.faqBtnColor = Colors.blue,
    // this.sendBtnColor = Colors.blue,
    this.customerBackGroundColor = const Color(0xFFEAEAEA),
    this.userBackGroundColor = const Color(0xFFEAEAEA),
    // this.selectPicColor = Colors.blue,
    // this.alreadyReadColor = Colors.blue,
    this.unReadColor = const Color(0xFF999999),
    this.tipColor = const Color(0xFF999999),
    this.appBarColor,
    this.backgroundColor, //注意：不要设置默认颜色
  });
}

///记录跳转之后的用户信息
// class UserInfo {
//   static String avatar;
//   static String username;
//   static String connectUrl;
// }
