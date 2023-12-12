/*
 * @Author: your name
 * @Date: 2020-05-23 11:12:17
 * @LastEditTime: 2020-05-26 22:28:50
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /zaixiankefu/lib/chat_widget/chat_core/network/connection/chat_color.dart
 */

///基础颜色配置
import 'package:flutter/material.dart';

class ChatColor {
  ///获取当前未读消息数
  static ValueChanged<int> getMsg;
  ///faq 官方助手头像----svg图片
  static String faqHeadImgPath;

  ///字体基础颜色
  static Color baseColor;

  ///FAQ 问题分类颜色
  static Color classItemColor;

  ///各个问题的字体颜色
  static Color questionColor;

  ///已解决 未解决 其他疑问 字体颜色
  static Color faqBtnColor;

  ///已解决 未解决 其他疑问背景颜色颜色
  static Color faqBtnBackgroundColor;

  ///发送按钮的字体颜色
  static Color sendBtnColor;

  ///客服对话框背景颜色
  static Color customerBackGroundColor;

  ///用户对话框背景颜色
  static Color userBackGroundColor;

  ///选择图片上传的按钮颜色
  static Color selectPicColor;

  ///已读状态 颜色
  static Color alreadyReadColor;

  ///未读状态颜色
  static Color unReadColor;

  ///提示文字颜色
  static Color tipColor;

  ///背景色
  static Color backgroundColor;

  ///昵称的字体颜色
  static Color nicknameColor;

}
