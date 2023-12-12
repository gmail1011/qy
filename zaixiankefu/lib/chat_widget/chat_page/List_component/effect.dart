import 'dart:async';

import 'package:chat_online_customers/chat_widget/chat_core/network/connection/connect_util.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/download_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/msg_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/utils/file_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_page/action.dart';
import 'package:chat_online_customers/chat_widget/chat_page/key_board_component/action.dart';
import 'package:chat_online_customers/chat_widget/utils/logger.dart';
import '../../chat_core/time_tool/date_util.dart';
import '../../chat_core/network/connection/notification_center.dart';
import '../../chat_core/pkt/pb.pb.dart';
import '../../chat_model/chatFaqModel.dart';
import '../../chat_page/utils/tool.dart';
import '../../chat_page/utils/util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:fixnum/fixnum.dart';
import 'action.dart';
import 'state.dart';

Effect<ListState> buildEffect() {
  return combineEffects(<Object, Effect<ListState>>{
    ListAction.action: _onAction,
    ListAction.getHistoryMsg: _onGetHistory,
    ListAction.sendHistoryRequest: _onSendReques,
    ListAction.waitAction: _onWait,
    ListAction.refuseConnect: _onRefuse,
    ListAction.solveQuest: _onSolve,
    ListAction.otherQuest: _onOther,
    ListAction.sendNotification: _oSendNoti,
    ListAction.sendMsgIsRead: _onSendReadStatus,
    ListAction.showMsg: _onShow,
    ListAction.reconnectAfterDisconnection: _reconnectAfterDisconnection,
  });
}

void _onAction(Action action, Context<ListState> ctx) {}

void _onShow(Action action, Context<ListState> ctx) {
  dynamic childFields = action.payload;
  //消息过滤
  if (ctx.state.list.length > 0) {
    var rlist = ctx.state.list.where((element) =>
        (element is ChatFields &&
            element?.messageId == childFields?.messageId) ||
        (element is ChatAudio && element?.messageId == childFields?.messageId));
    if (rlist.toList().length > 0) {
      print("消息重复，停止渲染");
      return;
    }
  }
  if (ctx.state.list.length > 0) {
    dynamic data = ctx.state.list.first;
    if (childFields.time.toString() != null) {
      var oldTime = int.parse(data.time.toString());
      bool dif = DateUtil.timeDiffrence(oldTime);
      if (dif == true) {
        ServicerInfoFields servicerInfoFields = ServicerInfoFields.create();
        servicerInfoFields.declaration =
            showAllTime(DateTime.now().millisecondsSinceEpoch);
        ctx.dispatch(ListActionCreator.onShowChatFields(servicerInfoFields));
      }
    }
  }
  if (childFields.messageId != null) {
    Map map = {childFields.messageId: "1"};
    ctx.dispatch(ListActionCreator.uplateMsgStatus(map));

    const timeout = const Duration(seconds: 10);
    ctx.state.sendTimer.add({
      "id": childFields.messageId,
      "timer": Timer(timeout, () {
        ctx.state.sendMsgStatus[childFields.messageId] = "2";
        ctx.dispatch(ListActionCreator.onRefresh());
      })
    });
  }
  ctx.dispatch(ListActionCreator.onShowChatFields(childFields));
}

//发送当前已读消息到websocket】
void _onSendReadStatus(Action action, Context<ListState> ctx) async {
  //获取当前用户所阅读的消息索引 数组
  var list = action.payload;
  List<String> dl = List();

  if (list.length > 0) {
    for (var i = 0; i < list.length; i++) {
      var s = list[i] ?? 0;
      if (s < ctx.state.list.length) {
        dynamic data = ctx.state.list[s];

        if (data is ChatFields &&
            data.type != null &&
            data.messageId != null &&
            data.type != 1) {
          if (data.isRead != 2) {
            data.isRead = 2;
            dl.add(data.messageId);
            print('*******messageId****${data.messageId}');
          }
        }
      }
    }
    print('*******dl****$dl');
    if (dl.length > 0) {
      //组装当前已阅读的消息数据 传回服务器
      UpdateReadType updateReadType = UpdateReadType.create()
        ..senderId = await obtainValueByKey('id') ?? ''
        ..targetId = await obtainValueByKey('servicerId') ?? ''
        ..sessionId = await obtainValueByKey('sessionId') ?? ''
        ..msgs.addAll(dl);
      BaseMessage baseMessage = BaseMessage.create();
      baseMessage.action = 1006;
      baseMessage.data = updateReadType.writeToBuffer();
      MsgUtils.sendMessage(baseMessage.writeToBuffer());
    }
  }
}

//发送通知 取消定时器
void _oSendNoti(Action action, Context<ListState> ctx) {
  NotificationCenter.post('cancel');
}

// 用户因为被禁言或者其他原因拒绝连接服务器  协议号=====2000
void _onRefuse(Action action, Context<ListState> ctx) {
  RejectPlayer rejectPlayer = action.payload;
  FreezePlayer freezePlayer = FreezePlayer.create();
  String refuseTime = showAllTime(rejectPlayer.time);
  freezePlayer.type = 1;
  freezePlayer.reason =
      rejectPlayer.type == 1 ? "亲，您已被禁言\n禁言截止时间 $refuseTime" : "";
  ctx.dispatch(KeyBoardActionCreator.onDontTalk(freezePlayer));
}

//当前没有客服在线 需要等待
void _onWait(Action action, Context<ListState> ctx) {
  QueueInfo queueInfo = action.payload;
  ctx.state.waitCount = queueInfo.waitCount;
  ServicerInfoFields servicerInfoFields = ServicerInfoFields.create();
  servicerInfoFields.declaration =
      "当前系统客服繁忙，您已在排队等待中！当前排队人数${queueInfo.waitCount}人...";
  ctx.dispatch(ListActionCreator.onShowChatFields(servicerInfoFields));
  // ctx.dispatch(ChatActionCreator.onChangeKeyBoardAction(true));
}

// 断线重连
void _reconnectAfterDisconnection(Action action, Context<ListState> ctx) {
  ctx.state.socketType = SocketStateEnum.CONNECTING;
  ctx.broadcast(ChatActionCreator.onConnect());
}

//发送历史消息请求历史消息记录
void _onSendReques(Action action, Context<ListState> ctx) async {
  // ctx.state.isScrollToBottom = true;
  HistoryMessage historyMessage = HistoryMessage.create();
  historyMessage.id = await obtainValueByKey('id') ?? '';
  historyMessage.platId = await obtainValueByKey('platId') ?? '';
  historyMessage.currentSessionId =
      Instance.currentSessionId ?? await obtainValueByKey('sessionId') ?? '';
  BaseMessage baseMessage = BaseMessage.create();
  baseMessage.action = 1008;
  baseMessage.data = historyMessage.writeToBuffer();

  MsgUtils.sendMessage(baseMessage.writeToBuffer());
}

//点击已解决按钮 事件
void _onSolve(Action action, Context<ListState> ctx) async {
  ctx.dispatch(ListActionCreator.onSendNotification());

  if (ctx.state.isScrollToBottom == false) {
    ctx.dispatch(ListActionCreator.onChangeIsScrollToBottom(true));
  }
  String string = action.payload;
  int nowTime = DateTime.now().millisecondsSinceEpoch;
  ChatFields chatFields = ChatFields.create()
    ..sessionId = await obtainValueByKey('sessionId') ?? ''
    ..text = string
    ..time = Int64(nowTime)
    ..username = await obtainValueByKey('username') ?? ''
    ..targetId = await obtainValueByKey('servicerId') ?? ''
    ..type = 1
    ..isRead = 2
    ..senderId = await obtainValueByKey('id') ?? '';
  ctx.dispatch(ListActionCreator.onShowChatFields(chatFields));

  Future.delayed(Duration(seconds: 1), () {
    TimeDownBean bean = TimeDownBean();
    bean.time = 10;
    bean.type = 1;
    ctx.dispatch(ListActionCreator.onShowChatFields(bean));
  });
}

//点击其他疑问按钮 事件
void _onOther(Action action, Context<ListState> ctx) async {
  ctx.dispatch(ListActionCreator.onSendNotification());
  if (ctx.state.isScrollToBottom == false) {
    ctx.dispatch(ListActionCreator.onChangeIsScrollToBottom(true));
  }
  String string = action.payload;
  int nowTime = DateTime.now().millisecondsSinceEpoch;
  ChatFields chatFields = ChatFields.create()
    ..sessionId = await obtainValueByKey('sessionId') ?? ''
    ..text = string
    ..time = Int64(nowTime)
    ..username = await obtainValueByKey('username') ?? ''
    ..targetId = await obtainValueByKey('servicerId') ?? ''
    ..type = 1
    ..isRead = 2
    ..senderId = await obtainValueByKey('id') ?? ''
    ..messageId = nowTime.toString();
  ctx.dispatch(ListActionCreator.onShowChatFields(chatFields));
  if (Instance.faqModel != null) {
    Future.delayed(Duration(seconds: 1), () {
      // FaqModel faqModel = ctx.state.faqModel;

      ctx.dispatch(ListActionCreator.onShowChatFields(Instance.faqModel));
    });
  }
}

//获取历史消息
void _onGetHistory(Action action, Context<ListState> ctx) {
  MessageList messageList = action.payload;
  Instance.currentSessionId = messageList.sessionId;
  print('=========messageList===========$messageList');
  if (messageList.msgs.length > 0) {
    ctx.state.controller.loadComplete();
    ctx.state.controller.refreshCompleted();
    ctx.dispatch(ListActionCreator.onSetSessionId(messageList.sessionId));
  } else {
    ctx.state.controller.loadComplete();
    ctx.state.controller.refreshCompleted();
  }

  ctx.dispatch(ListActionCreator.onShowChatFields(messageList.msgs));
  downloadHistoryData(messageList.msgs);
}

void downloadHistoryData(List list) {
  // var msgs = list.length > 0 ? list[0].msgs : [];
  for (var i = 0; i < list.length; i++) {
    ChatFields chatFields = list[i];
    Future.delayed(Duration(milliseconds: 500), () {
      _downloadVoice(chatFields);
    });
  }
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
