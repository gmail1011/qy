/*
 * @Author: your name
 * @Date: 2020-05-22 19:45:09
 * @LastEditTime: 2020-05-25 17:19:48
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /zaixiankefu/lib/chat_widget/chat_page/List_component/state.dart
 */
// import 'dart:ffi';
import 'dart:io';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/msg_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_model/chat_faq_model.dart';
import 'package:chat_online_customers/chat_widget/chat_page/List_component/view.dart';

import '../../chat_core/pkt/pb.pb.dart';
import '../../chat_model/chatFaqModel.dart';
import 'package:fish_redux/fish_redux.dart';

class ListState implements Cloneable<ListState> {
  // 用户信息
  PlayerInfo playerInfo;
  //前端传过来的值用新的PlayerInfo接收
  PlayerInfo forcePlayerInfo;

  // 客服返回信息
  ChatFields chatFields;
  // 客服基本信息
  ServicerInfoFields servicerInfoFields;
  //展示faq数据的时候 需要配置顶部时间展示 定义为ServicerInfoFields类型
  ServicerInfoFields timeServicerInfoFields;
  // 数据列表
  List<dynamic> list;

  //是否需要滑动到底部
  bool isScrollToBottom;

  // 上传文件状态集合
  Map<String, File> images;

  //记录当前的session_id 用来拉去历史记录
  String currentSessionId;

  //客服头像
  String customerAvatar;
  //客服名字
  String customername;
  //用户头像
  String userAvatar;
  //用户名字
  String username;
  //判断当前是否连接websocket 通过判断键盘是否隐藏来决定
  bool isNeedKeyboard;

  // 本地图片加载遮罩层
  Map<String, bool> loadingState;

//faq问题集
  QuestBean questBean;
  //记录faq数据
  FaqModel faqModel;

  int questType;

  //LIstView是否倒置 默认是false
  bool reverse;

  //记录当前选择的问题分类
  String currentQuestion;
  //记录当前分类问题下的答案
  ChatAnwserModel chatAnwserModel;

  // bool isConnect;

  ObtainRefreshController controller = ObtainRefreshController();

  // 正在连接...
  String pointText = "正在连接服务器...";

  // socket 状态
  var socketType = MsgUtils.state();

  // 发送消息状态
  Map sendMsgStatus = {};
  List sendTimer = [];
  // 排队时间
  int waitCount;

  @override
  ListState clone() {
    return ListState()
      ..playerInfo = playerInfo
      ..list = list
      ..servicerInfoFields = servicerInfoFields
      ..chatFields = chatFields
      ..isScrollToBottom = isScrollToBottom
      ..currentSessionId = currentSessionId
      ..customername = customername
      ..customerAvatar = customerAvatar
      ..userAvatar = userAvatar
      ..username = username
      ..loadingState = loadingState
      ..images = images
      ..currentSessionId = currentSessionId
      ..forcePlayerInfo = forcePlayerInfo
      ..isNeedKeyboard = isNeedKeyboard
      ..timeServicerInfoFields = timeServicerInfoFields
      ..questBean = questBean
      ..faqModel = faqModel
      ..reverse = reverse
      ..controller = controller
      // ..isConnect = isConnect
      ..questType = questType
      ..currentQuestion = currentQuestion
      ..chatAnwserModel = chatAnwserModel
      ..pointText = pointText
      ..socketType = socketType
      ..sendMsgStatus = sendMsgStatus
      ..waitCount = waitCount
      ..sendTimer = sendTimer;
  }
}

ListState initState(Map<String, dynamic> args) {
  ListState newState = ListState();
  return newState;
}
