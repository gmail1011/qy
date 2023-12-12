import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/utils/light_model.dart';

import 'action.dart';
import 'state.dart';

Reducer<NovelPlayerState> buildReducer() {
  return asReducer(
    <Object, Reducer<NovelPlayerState>>{
      NovelPlayerAction.showAppBar: _showAppBar,
      NovelPlayerAction.changeColor: _changeColor,
      NovelPlayerAction.saveCurrentText: _saveCurrentText,
      NovelPlayerAction.changeTipArrow: _changeTipArrow,
      NovelPlayerAction.saveData: _saveData,
    },
  );
}

NovelPlayerState _saveCurrentText(NovelPlayerState state, Action action) {
  final NovelPlayerState newState = state.clone();
  newState.currentTextList = action.payload;
  return newState;
}

NovelPlayerState _saveData(NovelPlayerState state, Action action) {
  final NovelPlayerState newState = state.clone();
  newState.novelData = action.payload;
  return newState;
}

NovelPlayerState _changeColor(NovelPlayerState state, Action action) {
  final NovelPlayerState newState = state.clone();
  newState.colorModel = action.payload;
  lightKV.setInt('novelBgColor', newState.colorModel.bgColor.value);
  lightKV.setInt('novelTextColor', newState.colorModel.textColor.value);
  return newState;
}

NovelPlayerState _showAppBar(NovelPlayerState state, Action action) {
  final NovelPlayerState newState = state.clone();
  newState.isShowAppBar = action.payload;
  return newState;
}

NovelPlayerState _changeTipArrow(NovelPlayerState state, Action action) {
  final NovelPlayerState newState = state.clone();
  newState.tipArrowShow = action.payload;
  if (newState.tipArrowShow) {
    lightKV.setString('TOPIC_TIP_SHOWa', 'true');
  }
  return newState;
}
