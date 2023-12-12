import 'package:chat_online_customers/chat_widget/chat_core/network/connection/connect_util.dart';

import '../chat_core/pkt/pb.pb.dart';
import '../chat_model/chatFaqModel.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ChatState> buildReducer() {
  return asReducer(
    <Object, Reducer<ChatState>>{
      ChatAction.action: _onAction,
      ChatAction.playerInfo: _onPlayerInfo,
      ChatAction.servicerInfoFields: _onServicerInfoFields,
      ChatAction.onShow2005Data: _onChatUserInfo,
      ChatAction.typing: _onTyping,
      ChatAction.clearTyping: _onClearTyping,
      ChatAction.changeKeyBoardAction: _onChangeKeyBoard,
      ChatAction.saveFullQuestBean: _onSaveFullQuest,
      ChatAction.saveFaqData: _onSaveFaq,
      ChatAction.connectDealData: _onconnectDeal,
      ChatAction.hideOrShowFloatingBtn: _onHideOrShowFloatBtn,
      ChatAction.recordUI: _onRecordUI,
      ChatAction.cancelRecordUI: _onCancelRecordUI,
      ChatAction.refresh: _refresh,
    },
  );
}

// 链接成功之后将faq数据颠倒顺序
ChatState _onCancelRecordUI(ChatState state, Action action) {
  ChatState newState = state.clone()..isHideRecord = true;
  return newState;
}

ChatState _refresh(ChatState state, Action action) {
  ChatState newState = state.clone();
  return newState;
}

// 链接成功之后将faq数据颠倒顺序
ChatState _onRecordUI(ChatState state, Action action) {
  ChatState newState = state.clone()
    ..voiceContent = action.payload
    ..isHideRecord = false;
  return newState;
}

// 链接成功之后将faq数据颠倒顺序
ChatState _onHideOrShowFloatBtn(ChatState state, Action action) {
  ChatState newState = state.clone()..offstage = action.payload;
  return newState;
}

// 链接成功之后将faq数据颠倒顺序
ChatState _onconnectDeal(ChatState state, Action action) {
  final ChatState newState = state.clone();
  List<dynamic> list = List();
  if (state.list.length > 0) {
    for (var i = 0; i < state.list.length; i++) {
      dynamic data = state.list[i];
      list.insert(0, data);
    }
  }
  newState.list = list;
  return newState;
}

// 清空正在输入
ChatState _onClearTyping(ChatState state, Action action) {
  final ChatState newState = state.clone()..typing = null;
  return newState;
}

// 是否显示输入
ChatState _onChangeKeyBoard(ChatState state, Action action) {
  final ChatState newState = state.clone()..isNeedKeyboard = action.payload;
  return newState;
}

// 对方正在输入
ChatState _onTyping(ChatState state, Action action) {
  final ChatState newState = state.clone()..typing = '对方正在输入...';
  return newState;
}

ChatState _onAction(ChatState state, Action action) {
  final ChatState newState = state.clone();
  return newState;
}

ChatState _onSaveFullQuest(ChatState state, Action action) {
  QuestBean questBean = action.payload;
  ChatState newState = state.clone();
  newState.questBean = questBean;
  return newState;
}

ChatState _onSaveFaq(ChatState state, Action action) {
  FaqModel faqModel = action.payload;
  ChatState newState = state.clone();
  newState.faqModel = faqModel;
  return newState;
}

ChatState _onPlayerInfo(ChatState state, Action action) {
  final ChatState newState = state.clone()..playerInfo = action.payload;
  return newState;
}

ChatState _onServicerInfoFields(ChatState state, Action action) {
  ServicerInfoFields servicerInfoFields = action.payload;
  ChatFields chatFields = ChatFields.create();
  chatFields.text = servicerInfoFields.declaration;
  final ChatState newState = state.clone()
    ..servicerInfoFields = servicerInfoFields
    ..list.insert(0, chatFields)
    ..currentSessionId = servicerInfoFields.sessionId;
  Instance.customerAvatar = servicerInfoFields.avatar;
  Instance.customerUsername = servicerInfoFields.username;
  return newState;
}

ChatState _onChatUserInfo(ChatState state, Action action) {
  ChatState newState = state.clone();
  List list = action.payload.list;
  var msgs = list.length > 0 ? list[0].msgs : [];
  List l = List();
  for (var i = 0; i < msgs.length; i++) {
    var d = msgs[i];
    if (state.reverse == false) {
      l.add(d);
    } else {
      l.insert(0, d);
    }
  }
  newState.list.addAll(l);
  // final ChatState newState = state.clone()..list.insertAll(0,data);
  return newState;
}
