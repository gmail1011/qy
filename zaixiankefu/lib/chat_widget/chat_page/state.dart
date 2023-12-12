// import 'dart:ffi';
import 'dart:io';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/connect_util.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_page/key_board_component/state.dart';
import 'package:chat_online_customers/chat_widget/chat_page/voice_component/state.dart';
import '../chat_model/userModel.dart';
import 'package:flutter/material.dart';
import '../chat_core/pkt/pb.pb.dart';
import '../chat_model/chatFaqModel.dart';
import 'package:fish_redux/fish_redux.dart';

import 'List_component/state.dart';

class ChatState implements Cloneable<ChatState> {
  // userModel model;
  // List<msgModel> datas = List();
  // 用户信息
  PlayerInfo playerInfo;

  //前端传过来的数据 重新定义PlayerInfo来接收
  PlayerInfo forcePlayerInfo;

  // 客服信息
  ServicerInfoFields servicerInfoFields;

  //展示faq数据的时候 需要配置顶部时间展示 定义为ServicerInfoFields类型
  ServicerInfoFields timeServicerInfoFields;

  //是否禁言
  FreezePlayer freezePlayer;

  // 消息内容
  String text;

  // 返回信息
  ChatFields chatFields;

  // 消息列表
  List<dynamic> list = List();

  // 客服断开信息
  EnterStatus enterStatus;

  // 对方正在输入消息
  String typing;

  // 是否是匿名用户
  String anonymous;

  //是否需要滑动到底部
  bool isScrollToBottom = true;

//是否禁言 未禁言状态：false 禁言状态：true
  bool isNoTalk = false;

  //记录当前的session_id
  String currentSessionId = '';

  //是否需要显示或隐藏底部输入框   false不隐藏  true隐藏
  bool isNeedKeyboard = true;

  //下面的字段是webSocket未连接的时候  由上一个页面传递下来的
  //用户名
  String username = '';

  //用户头像
  String userAvatar = '';

  //客服头像
  String customerAvatar = '';

  //客服名字
  String customername = '';

  //用户的appId
  String appId = '';

  List<String> picList = List();

  // 对应子组件本地图片加载
  Map<String, bool> loadingState = Map();

  // 图片上传
  Map images = Map<String, File>();

  //faq数据
  FaqModel faqModel;

  //faq问题集
  QuestBean questBean;

  //questype 当前记录的问题
  int questType = 0;

  //当前可用域名
  String baseUrl;

  //是否已经连接webSocket
  // bool isConnect = false;
  //ListView是否倒置  默认不倒置
  bool reverse = false;

  //隐藏悬乎按钮
  bool offstage = true;

  bool isVoice = false;

  ///是否隐藏音频录制是的UI
  bool isHideRecord = true;

  ///当前语音录制状态的内容
  String voiceContent;

  TextEditingController editController = TextEditingController();

  Map sendMsgStatus = {};
  List sendTimer = [];
  int waitCount;
  @override
  ChatState clone() {
    return ChatState()
      ..servicerInfoFields = servicerInfoFields
      ..chatFields = chatFields
      ..playerInfo = playerInfo
      ..appId = appId
      ..baseUrl = baseUrl
      ..typing = typing
      ..list = list
      ..images = images
      ..anonymous = anonymous
      ..loadingState = loadingState
      ..picList = picList
      ..isScrollToBottom = isScrollToBottom
      ..currentSessionId = currentSessionId
      ..freezePlayer = freezePlayer
      ..faqModel = faqModel
      ..isNeedKeyboard = isNeedKeyboard
      ..username = username
      ..userAvatar = userAvatar
      ..customerAvatar = customerAvatar
      ..customername = customername
      ..forcePlayerInfo = forcePlayerInfo
      ..isNeedKeyboard = isNeedKeyboard
      ..timeServicerInfoFields = timeServicerInfoFields
      ..faqModel = faqModel
      ..questBean = questBean
      // ..isConnect = isConnect
      ..reverse = reverse
      ..questType = questType
      ..offstage = offstage
      ..editController = editController
      ..isHideRecord = isHideRecord
      ..voiceContent = voiceContent
      ..sendMsgStatus = sendMsgStatus
      ..waitCount = waitCount
      ..sendTimer = sendTimer;
  }
}

ChatState initState(KefuUserModel model) {
  String connectUrl = model.connectUrl; //args['connectUrl'];
  var u = Uri.parse(connectUrl);
  var currentAppId;
  if (connectUrl.contains('appId')) {
    String s = connectUrl.split('appId=').last;
    currentAppId = s.split('&').first;
  }
  // currentAppId = '123456';//'4514506392';
  // ChatFields chatFields = ChatFields.create();
  // chatFields.text = '亲！您好呀，24小时在线客服MM竭诚为您服务，请耐心等待，客服小姐姐正在全力接洽中～～～';
  ChatState newState = ChatState()
    ..anonymous = u.queryParameters['anonymous']
    ..appId = currentAppId
    ..userAvatar = model.avatar
    ..username = model.username
    ..baseUrl = model.baseUrl;
  if (!model.connectUrl.contains('sign')) {
    Instance.isAnonymous = true;
  }
  return newState;
}

class ListConnector extends ConnOp<ChatState, ListState> {
  @override
  ListState get(ChatState page) {
    final ListState sub = ListState()
      ..chatFields = page.chatFields
      ..list = page.list
      ..images = page.images
      ..servicerInfoFields = page.servicerInfoFields
      ..playerInfo = page.playerInfo
      ..isScrollToBottom = page.isScrollToBottom
      ..currentSessionId = page.currentSessionId
      ..customerAvatar = page.customerAvatar
      ..customername = page.customername
      ..userAvatar = page.userAvatar
      ..username = page.username
      ..loadingState = page.loadingState
      ..currentSessionId = page.currentSessionId
      ..forcePlayerInfo = page.forcePlayerInfo
      ..isNeedKeyboard = page.isNeedKeyboard
      ..timeServicerInfoFields = page.timeServicerInfoFields
      ..questBean = page.questBean
      ..faqModel = page.faqModel
      ..reverse = page.reverse
      ..questType = page.questType
      ..sendMsgStatus = page.sendMsgStatus
      ..waitCount = page.waitCount
      ..sendTimer = page.sendTimer;
    return sub;
  }

  @override
  void set(ChatState page, ListState sub) {
    page.playerInfo = sub.playerInfo;
    page.chatFields = sub.chatFields;
    page.servicerInfoFields = sub.servicerInfoFields;
    page.list = sub.list;
    page.images = sub.images;
    page.loadingState = sub.loadingState;
    page.isScrollToBottom = sub.isScrollToBottom;
    page.currentSessionId = sub.currentSessionId;
    page.customername = sub.customername;
    page.customerAvatar = sub.customerAvatar;
    page.username = sub.username;
    page.userAvatar = sub.userAvatar;
    page.forcePlayerInfo = sub.forcePlayerInfo;
    page.isNeedKeyboard = sub.isNeedKeyboard;
    page.timeServicerInfoFields = sub.timeServicerInfoFields;
    page.questBean = sub.questBean;
    page.faqModel = sub.faqModel;
    page.reverse = sub.reverse;
    page.questType = sub.questType;
    page.sendMsgStatus = sub.sendMsgStatus;
    page.waitCount = sub.waitCount;
    page.sendTimer = sub.sendTimer;
  }
}

class KeyBoardConnector extends ConnOp<ChatState, KeyBoardState> {
  @override
  KeyBoardState get(ChatState page) {
    final KeyBoardState sub = KeyBoardState()
      ..playerInfo = page.playerInfo
      ..editController = page.editController
      ..servicerInfoFields = page.servicerInfoFields
      ..appId = page.appId
      ..enterStatus = page.enterStatus
      ..photo = page.picList
      ..images = page.images
      ..freezePlayer = page.freezePlayer
      ..faqModel = page.faqModel
      ..list = page.list
      ..isVoice = page.isVoice
      ..isHideRecord = page.isHideRecord;
    return sub;
  }

  @override
  void set(ChatState page, KeyBoardState sub) {
    page
      ..playerInfo = sub.playerInfo
      ..editController = sub.editController
      ..chatFields = page.chatFields
      ..servicerInfoFields = sub.servicerInfoFields
      ..appId = sub.appId
      ..images = sub.images
      ..enterStatus = sub.enterStatus
      ..picList = sub.photo
      ..freezePlayer = sub.freezePlayer
      ..faqModel = sub.faqModel
      ..list = sub.list
      ..isVoice = sub.isVoice
      ..isHideRecord = sub.isHideRecord;
  }
}

class VoiceConnector extends ConnOp<ChatState, VoiceState> {
  @override
  VoiceState get(ChatState page) {
    final VoiceState sub = VoiceState();
    sub.voiceContent = page.voiceContent;
    return sub;
  }

  @override
  void set(ChatState page, VoiceState sub) {
    page.voiceContent = sub.voiceContent;
  }
}
