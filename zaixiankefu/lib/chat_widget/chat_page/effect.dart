import 'dart:async';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/download_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/msg_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/utils/file_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/utils/sound_helper.dart';
import 'package:chat_online_customers/chat_widget/chat_model/chat_faq_model.dart';
import 'package:chat_online_customers/chat_widget/chat_page/bullet_box/bulletBox.dart';
import 'package:chat_online_customers/chat_widget/chat_page/key_board_component/action.dart';
import 'package:chat_online_customers/chat_widget/utils/logger.dart';
import 'package:flutter/material.dart' hide Action;
import '../chat_core/network/connection/connect_util.dart';
import '../chat_core/network/connection/dio_manager.dart';
import '../chat_core/pkt/pb.pb.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:fixnum/fixnum.dart';
import 'List_component/action.dart';
import 'action.dart';
import 'state.dart';
import 'utils/tool.dart';
import 'utils/util.dart';

// 全局上下文，确保二次进入页面时，发状态上下文为最新
dynamic _ctx;
// 清空正在输入
dynamic _typingTimer;
Effect<ChatState> buildEffect() {
  return combineEffects(<Object, Effect<ChatState>>{
    ChatAction.action: _onAction,
    Lifecycle.initState: _init,
    ChatAction.selectFaqQuestionItem: _onSelectFaqItem,
    ChatAction.selectAnwser: _onAnwser,
    Lifecycle.dispose: _dispose,
    Lifecycle.deactivate: _deactivate,
    ChatAction.connectWebSocket: _connectWeb,
    ChatAction.chatUserInfo: _chatUserInfo,
    ChatAction.getVoiceData: _onGetVoice,
    ChatAction.aswer: _aswer,
    ChatAction.connect: _onConnect,
  });
}

void _deactivate(Action action, Context<ChatState> ctx) {
  FocusScope.of(ctx.context).requestFocus(FocusNode());
}

void _onAction(Action action, Context<ChatState> ctx) {}

// 确认收到信息
void _aswer(Action action, Context<ChatState> ctx) {
  AckReplyPacket payload = action.payload;
  String messageId = payload.messageId ?? "";
  ctx.state.sendMsgStatus[messageId] = 3;
  if (ctx.state.sendTimer.length == 0) return;
  ctx.state.sendTimer.forEach((i) => {
        if (i["id"] == messageId) {i["timer"].cancel()}
      });
  ctx.dispatch(ChatActionCreator.onRefresh());
}

// 发送应答
void _sendAswer(data) {
  String sessionId = data.sessionId ?? "";
  String messageId = data.messageId ?? "";
  String targetId = data.targetId ?? "";
  String senderId = data.senderId ?? "";
  AckReplyPacket ackReplyPacket = AckReplyPacket.create()
    ..senderId = senderId
    ..sessionId = sessionId
    ..targetId = targetId
    ..messageId = messageId;

  BaseMessage baseMessage = BaseMessage.create();
  baseMessage.action = 1018;
  baseMessage.data = ackReplyPacket.writeToBuffer();
  PrintUtil().log("发送消息:1018");
  MsgUtils.sendMessage(baseMessage.writeToBuffer());
}

// 页面初始化
void _init(Action action, Context<ChatState> ctx) async {
  // _onConnect(action, ctx);
  //初始化的时候先判断定时器是否已经释放 如果没有释放 就手动释放
  //这里的定时器是控制当前webSocket在五分钟后断开
  Instance.isCallBack = true;
  //初始化的时候将未读消息数设置为0
  Instance.count = 0;
  SocketManager().getMsg(0);
  _ctx = ctx;
  var appId = ctx.state.appId;
  Map<String, dynamic> map = Map();
  map['appId'] = appId; //测试appid == 456789
  //初始化获取faq数据
  if (Instance.isConnect == true) {
    // _onConnect(action, ctx);
    //连接成功之后  设置输入框不隐藏
    ctx.dispatch(ChatActionCreator.onChangeKeyBoardAction(false));
    ctx.dispatch(ListActionCreator.onChageReverseStatus(true));
    if (Instance.isShut == true) {
      _onConnect(action, ctx);
      MsgUtils.sendMsgToRequestLastTimeData();
      return;
    }
    if (Instance.isAnonymous == true) {
      _onConnect(action, ctx);
    } else {
      // _sendMsgToRequestLastTimeData();
      MsgUtils.sendMsgToRequestLastTimeData();
      Future.delayed(Duration(milliseconds: 500), () {
        _sendMsgToRequestHistoryData();
      });
    }

    // ctx.broadcast(ListActionCreator.onSendHistoryRequest());
    return;
  }
  if ((SocketManager().model?.faqApi?.length ?? 0) > 0 &&
      Instance.isConnect == false) {
    DioUtils.requestHttp(SocketManager().model.faqApi,
        parameters: map, method: DioUtils.POST, onSuccess: (data) {
      print('======data===$data');
      try {
        ChatFaqModel model = ChatFaqModel.fromMap(data);
        if (model?.data != null && model.data.length > 0) {
          //设置listView是否倒置 false不倒置 从上往下排列
          ctx.dispatch(ListActionCreator.onChageReverseStatus(false));
          // ServicerInfoFields servicerInfoFields = ServicerInfoFields.create();
          // servicerInfoFields.declaration =
          //     showAllTime(DateTime.now().millisecondsSinceEpoch);
          // ctx.dispatch(ListActionCreator.onShowChatFields(servicerInfoFields));
          //==============================================faq修改前的处理  下==============================================================
          // FaqModel model = FaqModel.fromMap(data);
          // ctx.dispatch(ChatActionCreator.onSaveFaqData(model));
          // dealFaqClassData(model, ctx);
          //==============================================faq修改前的处理  上===============================================================
          Instance.faqModel = model;
          dealFaqClassData(model, ctx);
        } else {
          //如果数据没有返回就直接连接WebSocket
          _onConnect(action, ctx);
        }
      } catch (e) {
        _onConnect(action, ctx);
      }
    }, onError: (error) {
      // print('=====error=======$error');
      //如果faq数据获取失败  直接连接webSocket
      _onConnect(action, ctx);
    });
  } else {
    _onConnect(action, ctx);
  }
}

//获取faq数据 提取faq分类数据
void dealFaqClassData(dynamic data, Context<ChatState> ctx) {
  ChatFaqModel faqModel = data;
  //初始化显示faq数据之前 需要展示当前时间
  ServicerInfoFields servicerInfoFields = ServicerInfoFields.create()
    ..declaration = currentTime();
  //展示当前时间
  ctx.dispatch(ListActionCreator.onShowCurrentTime(servicerInfoFields));

  //展示faq问题组件
  ctx.dispatch(ListActionCreator.onShowChatFields(faqModel));
  //展示faq数据的时候  需要隐藏底部输入框  等连接websocket成功后再显示
  ctx.dispatch(ChatActionCreator.onChangeKeyBoardAction(true));
}

//选取faq相关分类下面的问题列表
void _onSelectFaqItem(Action action, Context<ChatState> ctx) {
  ctx.dispatch(ListActionCreator.onSendNotification());
  ChatDataBean bean = action.payload;
  ctx.dispatch(ListActionCreator.onChangeIsScrollToBottom(true));

  if (Instance.isConnect == false) {
    dealSendFaqMsgData(ctx, bean.questName);
    loadAnwserDataByHttp(bean, ctx.state.appId, ctx, action);
    //当socket未链接时  才展示faq
    // Future.delayed(Duration(seconds: 1), () {
    // ctx.dispatch(ListActionCreator.onShowChatFields(bean));

    // });
  } else {
    //链接成功之后  faq自动回复关闭 将问题直接以消息形式发送给服务器
    Map<String, dynamic> map = Map();
    map['text'] = bean.questName;
    ctx.dispatch(KeyBoardActionCreator.onSendMsg(map));
  }
}

//请求问题分类下面对应的答案
void loadAnwserDataByHttp(ChatDataBean bean, String appId,
    Context<ChatState> ctx, Action action) async {
  var appId = ctx.state.appId;
  Map<String, dynamic> map = Map();
  map['appId'] = appId;
  map['questType'] = bean.questType;
  DioUtils.requestHttp(
    SocketManager().model.faqApi,
    parameters: map,
    method: DioUtils.POST,
    onSuccess: (data) {
      ChatAnwserModel model = ChatAnwserModel.fromMap(data);
      ctx.dispatch(ListActionCreator.onShowChatFields(model));
    },
    onError: (e) {
      _onConnect(action, ctx);
    },
  );
}

//选取问题对应的答案
void _onAnwser(Action action, Context<ChatState> ctx) {
  //发送通知 取消当前定时器读秒 -> 这个定时器是用户不小心点了已解决按钮
  //有一个10s的倒计时自动退出页面 但是用户如果又操作了其他功能 就取消
  ctx.dispatch(ListActionCreator.onSendNotification());
  ctx.dispatch(ListActionCreator.onChangeIsScrollToBottom(true));

  Map<String, dynamic> map = action.payload;
  ChatResultModel resultModel = ChatResultModel.fromMap(map);

  if (Instance.isConnect == false) {
    dealSendFaqMsgData(ctx, resultModel.questTitle);
    //未链接webSocket的时候 才走faq流程
    Future.delayed(Duration(seconds: 1), () {
      ctx.dispatch(ListActionCreator.onShowChatFields(resultModel));
    });
  } else {
    Map<String, dynamic> map = Map();
    map['text'] = resultModel.questTitle ?? '';
    ctx.dispatch(KeyBoardActionCreator.onSendMsg(map));
  }
}

//处理faq用户数据 用来展示
void dealSendFaqMsgData(Context<ChatState> ctx, String text) {
  //如果连接的是faq数据 当前是没有连接websocket 所以需要自己手动设定用户的名字和头像相关信息
  var playerInfo = PlayerInfo.create()
    ..username = ctx.state.username
    ..avatar = ctx.state.userAvatar ?? '';
  ctx.state.forcePlayerInfo = playerInfo;
  //将用户选择的faq相关问题 拼接成ChatFields类型 用来统一展示
  int nowTime = DateTime.now().millisecondsSinceEpoch;
  ChatFields chatFields = ChatFields.create()
    ..username = ctx.state.username
    ..type = 1
    ..isRead = 2
    ..text = text
    ..time = Int64(nowTime);
  ctx.dispatch(ListActionCreator.onShowChatFields(chatFields));
}

//点击未解决  执行socket连接
void _connectWeb(Action action, Context<ChatState> ctx) async {
  //发送通知 取消当前定时器读秒 -> 这个定时器是用户不小心点了已解决按钮
  //有一个10s的倒计时自动退出页面 但是用户如果又操作了其他功能 就取消
  ctx.dispatch(ListActionCreator.onSendNotification());
  //链接成功之后 把faq数据顺序颠倒
  ctx.dispatch(ChatActionCreator.onConnectDealData());
  if (ctx.state.isScrollToBottom == false) {
    ctx.dispatch(ListActionCreator.onChangeIsScrollToBottom(true));
  }
  ctx.dispatch(ListActionCreator.onChageReverseStatus(true));
  String string = action.payload;
  int nowTime = DateTime.now().millisecondsSinceEpoch;
  ChatFields chatFields = ChatFields.create()
    ..sessionId = await obtainValueByKey('sessionId') ?? ''
    ..text = string ?? ''
    ..time = Int64(nowTime)
    ..username = await obtainValueByKey('username') ?? ctx.state.username
    ..targetId = await obtainValueByKey('servicerId') ?? ''
    ..type = 1
    ..isRead = 2
    ..senderId = await obtainValueByKey('id') ?? '';
  ctx.dispatch(ListActionCreator.onShowChatFields(chatFields));

  Future.delayed(Duration(seconds: 1), () {
    _onConnect(action, ctx);
  });
}

//连接webSocket
void _onConnect(Action action, Context<ChatState> ctx) async {
  // _ctx.dispatch(ListActionCreator.onReconnectAfterDisconnection());
  ctx.dispatch(ListActionCreator.onChageReverseStatus(true));
  String connectUrl = SocketManager().connectUrl;
  bool anonymous = Instance.isAnonymous;
  String id = await obtainValueByKey('id') ?? '';
  var url = anonymous != true ? connectUrl : connectUrl + '&userId=$id';
  if (connectUrl != null)
    await MsgUtils.longConnection(url, _listenMessageData);

  Instance.isConnect = true;

  //链接成功之后 改变isConnect的状态
  ctx.dispatch(ListActionCreator.onHideOrShowFaqBtn(true));
  //连接成功之后  设置输入框隐藏
  ctx.dispatch(ChatActionCreator.onChangeKeyBoardAction(true));
  //第一次连接websocket 让用户主动去拉取历史记录 不做自动拉取 暂时注释掉
  Future.delayed(Duration(milliseconds: 500), () {
    ctx.dispatch(ListActionCreator.onSendHistoryRequest());
  });
}

// 页面销毁
void _dispose(Action action, Context<ChatState> ctx) {
  // MsgUtils.closeSocket();
  _typingTimer?.cancel();
  _typingTimer = null;
  Instance.faqModel = null;
  Instance.isCallBack = false;
  Instance.isShut = false;
  sound_helper.stopPlayer();
  // Instance.closeWebScoket();
}

void _listenMessageData(dynamic action, dynamic data) async {
  PrintUtil().log("action:$action\n---------------------\n$data");
  var actio = selectAction(action, data);

  if (action == 2002) {
    _ctx.dispatch(ChatActionCreator.onChangeKeyBoardAction(false));
  }

  if (action == 2009) {
    showSimpleDialog(_ctx, data);
    _ctx.dispatch(ChatActionCreator.onChangeKeyBoardAction(true));
  }

  if (action == 2012) {
    _typingTimer?.cancel();
    _typingTimer = null;
    _typingTimer = Timer(Duration(milliseconds: 1500),
        () => _ctx.dispatch(ChatActionCreator.onClearTyping()));
  }
  if (actio != null) _ctx.dispatch(actio);

  if (action == 2003 || action == 2004) _sendAswer(data);
}

void _onGetVoice(Action action, Context<ChatState> ctx) {
  /*
  chatAudio
  int64 time = 1; // 消息发送时间
    string text = 2; // 消息内容
    string audio = 3; // 语音地址
    string targetId = 4; // 接受人ID
    string senderId = 5; // 发送者ID
    string messageId = 6; // 消息ID（接收）0
    int32 isRead = 7; // 是否已读（接收）
    string username = 8; // 发送者昵称
    string sessionId = 9; // 会话ID
    int32 type = 10; // 发送人类型
    int64 duration = 11; // 消息时长
  */

  ChatAudio chatAudio = action.payload;
  var audio = chatAudio.audio + '_' + chatAudio.duration.toString();
  ChatFields chatFields = ChatFields.create();
  chatFields.photo.add(audio ?? '');
  chatFields.time = chatAudio.time;
  chatFields.targetId = chatAudio.targetId;
  chatFields.senderId = chatAudio.senderId;
  chatFields.sessionId = chatAudio.sessionId;
  chatFields.text = chatAudio.text;
  chatFields.messageId = chatAudio.messageId;
  chatFields.username = chatAudio.username;
  chatFields.type = chatAudio.type;

  _downloadVoice(chatFields);
  ctx.dispatch(ListActionCreator.onShowChatFields(chatFields));
}

void _sendMsgToRequestHistoryData() async {
  HistoryMessage historyMessage = HistoryMessage.create();
  historyMessage.id = await obtainValueByKey('id') ?? '';
  historyMessage.platId = await obtainValueByKey('platId') ?? '';
  historyMessage.currentSessionId = await obtainValueByKey('sessionId') ?? '';
  BaseMessage baseMessage = BaseMessage.create();
  baseMessage.action = 1008;
  baseMessage.data = historyMessage.writeToBuffer();

  MsgUtils.sendMessage(baseMessage.writeToBuffer());
  _ctx.dispatch(ListActionCreator.onChangeIsScrollToBottom(true));
  _ctx.dispatch(ListActionCreator.onChageReverseStatus(true));
}

void _chatUserInfo(Action action, Context<ChatState> ctx) {
  List list = action.payload.list;
  var msgs = list.length > 0 ? list[0].msgs : [];
  print('===msgs====$msgs');
  for (var i = 0; i < msgs.length; i++) {
    ChatFields chatFields = msgs[i];
    Future.delayed(Duration(milliseconds: 500), () {
      _downloadVoice(chatFields);
    });
  }
  ctx.dispatch(ChatActionCreator.onShow2005Data(action.payload));
}

///下载语音 ///先判断是否是语音数据  再判断本地是否存在当前音频数据  有就不下载  没有就下载
void _downloadVoice(dynamic data) async {
  ChatFields chatFields = data;
  if (chatFields.photo != null && chatFields.photo.length > 0) {
    if (chatFields.photo.first.startsWith('aac')) {
      String path = await Network().isExist(chatFields);
      if (path.length == 0) {
        download(chatFields);
      }
    }
  }
}

void download(ChatFields chatFields) async {
  List l = chatFields.photo.first.split('_');
  var filename = "";
  for (var i = 0; i < l.length - 1; i++) {
    if (i == 0) {
      filename = l[0];
    } else {
      filename = filename + '_' + l[i];
    }
  }
  var localPath = await fileMgr.getRootPath() + '/' + filename + '.aac';
  String uri = SocketManager().model.baseUrl + '/audio/' + filename;
  try {
    Network().download(uri, localPath, (data) => {}, (e) => {});
  } catch (e) {
    print(e.toString());
  }
}
