
import 'dart:io';
import '../../chat_model/chatFaqModel.dart';

import '../../chat_core/pkt/pb.pb.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class KeyBoardState implements Cloneable<KeyBoardState> {
  // 用户信息
  PlayerInfo playerInfo;
  // 客服信息
  ServicerInfoFields servicerInfoFields;
  // 消息源
  ChatFields chatFields;
  // 图片地址
  List<String> photo;
  // 客户结束对话消息
  EnterStatus enterStatus;
  // 上传文件状态集合
  Map<String, File> images;

  //是否禁言理由
  FreezePlayer freezePlayer;
  //是否已经链接 默认否
  // bool isConnect;

  //faqModel
  FaqModel faqModel;

  //聊天内容
  List<dynamic> list;

  bool isVoice;

  bool isHideRecord;

TextEditingController editController;


  String sessionId;
  String avater;
  String name;
  String content;
  String userId;
  String appId;

  @override
  KeyBoardState clone() {
    return KeyBoardState()
    ..editController = editController
    ..sessionId = sessionId
    ..avater = avater
    ..content = content
    ..playerInfo = playerInfo
    ..chatFields = chatFields
    ..servicerInfoFields = servicerInfoFields
    ..enterStatus = enterStatus
    ..appId = appId
    ..photo = photo
    ..images = images
    ..appId = appId
    ..freezePlayer = freezePlayer
    ..faqModel = faqModel
    ..list = list
    ..isVoice = isVoice
    ..isHideRecord = isHideRecord;
  }
}

KeyBoardState initState(Map<String, dynamic> args) {
  
  return KeyBoardState();
}
