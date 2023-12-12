import 'package:chat_online_customers/chat_widget/chat_model/chat_faq_model.dart';

import '../chat_model/chatFaqModel.dart';
import 'package:fish_redux/fish_redux.dart';

enum ChatAction {
  action,
  playerInfo,
  servicerInfoFields,
  chatUserInfo,
  typing,
  clearTyping,
  selectFaqQuestionItem,
  selectAnwser,
  changeKeyBoardAction,
  saveFullQuestBean,
  connectWebSocket,
  saveFaqData,
  connectDealData,
  hideOrShowFloatingBtn,
  downloadVoiceData,
  onShow2005Data,
  getVoiceData,
  recordUI,
  cancelRecordUI,
  aswer,
  connect,
  refresh
}

class ChatActionCreator {
  static Action onRecordUI(String text) {
    return Action(ChatAction.recordUI, payload: text);
  }

  static Action cancelRecordUI() {
    return const Action(ChatAction.cancelRecordUI);
  }
  static Action onRefresh() {
    return const Action(ChatAction.refresh);
  }

  static Action onConnect() {
    return const Action(ChatAction.connect);
  }

  //获取语音消息 2014协议
  static Action onGetVoiceData(dynamic data) {
    return Action(ChatAction.getVoiceData, payload: data);
  }

  // 应答 2018
  static Action onAswer(dynamic data) {
    return Action(ChatAction.aswer, payload: data);
  }

  //下载语音数据
  static Action onDownloadVoiceData(dynamic data) {
    return Action(ChatAction.downloadVoiceData, payload: data);
  }

  //改变floattingButton的隐藏和显示
  static Action onHideOrShowFloatingBtn(bool isHide) {
    return Action(ChatAction.hideOrShowFloatingBtn, payload: isHide);
  }

  //点击未解决按钮 进行websocket连接
  static Action onConnectWebSocket(String content) {
    return Action(ChatAction.connectWebSocket, payload: content);
  }

  //链接成功之后将数据源里面的数据颠倒顺序
  static Action onConnectDealData() {
    return const Action(ChatAction.connectDealData);
  }

  // 对方正在输入
  static Action onTyping() {
    return Action(ChatAction.typing);
  }

  // 清空正在输入文字
  static Action onClearTyping() {
    return Action(ChatAction.clearTyping);
  }

  //选取Faq相关问题
  static Action onSelectFaqQuestionItem(ChatDataBean bean) {
    return Action(ChatAction.selectFaqQuestionItem, payload: bean);
  }

  //记录当前分类下面的问题集合
  static Action onSaveFullQuestBean(QuestBean bean) {
    return Action(ChatAction.saveFullQuestBean, payload: bean);
  }

  //记录faq数据
  static Action onSaveFaqData(FaqModel bean) {
    return Action(ChatAction.saveFaqData, payload: bean);
  }

  static Action onSelectAnwser(Map<String, dynamic> map) {
    return Action(ChatAction.selectAnwser, payload: map);
  }

  //是否需要显示键盘
  static Action onChangeKeyBoardAction(bool isNeedKeyBoard) {
    return Action(ChatAction.changeKeyBoardAction, payload: isNeedKeyBoard);
  }

  static Action onAction() {
    return const Action(ChatAction.action);
  }

  static Action onPlayerInfo(dynamic data) {
    return Action(ChatAction.playerInfo, payload: data);
  }

  static Action onServicerInfoFields(dynamic data) {
    return Action(ChatAction.servicerInfoFields, payload: data);
  }

  static Action onChatUserInfo(dynamic data) {
    return Action(ChatAction.chatUserInfo, payload: data);
  }

  static Action onShow2005Data(dynamic data) {
    return Action(ChatAction.onShow2005Data, payload: data);
  }
}
