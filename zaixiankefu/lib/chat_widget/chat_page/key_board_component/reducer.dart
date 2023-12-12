
import 'package:flutter/material.dart' hide Action;

import '../../chat_core/pkt/pb.pb.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<KeyBoardState> buildReducer() {
  return asReducer(
    <Object, Reducer<KeyBoardState>>{
      KeyBoardAction.action: _onAction,
      KeyBoardAction.enterStatus: _onEnterStatus,
      KeyBoardAction.shutUp: _onShutUp,
      KeyBoardAction.clearTextField : _onClear,
      KeyBoardAction.clickVoiceAction : _onClickVoice,
    },
  );
}
///点击语音按钮事件
KeyBoardState _onClickVoice(KeyBoardState state, Action action) {
  final KeyBoardState newState = state.clone()..isVoice = action.payload;
  return newState;
}
//清楚输入框内容
KeyBoardState _onClear(KeyBoardState state, Action action) {
  final KeyBoardState newState = state.clone();
  
  newState.editController.text = '';
  
  return newState;
}
KeyBoardState _onEnterStatus(KeyBoardState state, Action action) {
  final KeyBoardState newState = state.clone()..enterStatus = action.payload;
  return newState;
}

KeyBoardState _onAction(KeyBoardState state, Action action) {
  final KeyBoardState newState = state.clone();
  return newState;
}
KeyBoardState _onShutUp(KeyBoardState state, Action action) {
  FreezePlayer freezePlayer = action.payload;
  KeyBoardState newState = state.clone();
  newState.freezePlayer = freezePlayer;
  return newState;
}
