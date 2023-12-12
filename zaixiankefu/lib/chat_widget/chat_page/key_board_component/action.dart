import 'dart:io';

import 'package:chat_online_customers/chat_widget/chat_core/packets.dart';
import 'package:fish_redux/fish_redux.dart';

enum KeyBoardAction {
  action,
  sendMsg,
  upPicAction,
  dontTalk,
  enterStatus,
  startInput,
  shutUp,
  clearTextField,
  clickVoiceAction,
  recordVoice,
  stopRecord,
  voiceUp,
}

class KeyBoardActionCreator {
  ///停止录音
   static Action onStopRecord() {
    return const Action(KeyBoardAction.stopRecord);
  }
   static Action onVoiceUp(String path) {
    return Action(KeyBoardAction.voiceUp,payload: path);
  }
  ///录制语音
   static Action onRecordVoice() {
    return const Action(KeyBoardAction.recordVoice);
  }
  ///点击语音按钮
   static Action onClickVoiceAction(bool isvoice) {
    return  Action(KeyBoardAction.clickVoiceAction,payload: isvoice);
  }
  static Action onAction() {
    return const Action(KeyBoardAction.action);
  }
  static Action onClearTextField() {
    return const Action(KeyBoardAction.clearTextField);
  }

  static Action onSendMsg(Map<String, dynamic> map) {
    return Action(KeyBoardAction.sendMsg, payload: map);
  }

  static Action upPicAction(File image) {
    return Action(KeyBoardAction.upPicAction, payload: image);
  }

  static Action onDontTalk(dynamic data) {
    return Action(KeyBoardAction.dontTalk, payload: data);
  }

  static Action onShutUp(dynamic data) {
    return Action(KeyBoardAction.shutUp, payload: data);
  }

  // 客户结束会话
  static Action onEnterStatus(dynamic data) {
    return Action(KeyBoardAction.enterStatus, payload: data);
  }

  // 开始输入文本发送协议到后台
  static Action onStartInput() {
    return Action(KeyBoardAction.startInput);
  }
}
