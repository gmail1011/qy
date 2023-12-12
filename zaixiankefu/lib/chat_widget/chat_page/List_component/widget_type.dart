import 'package:chat_online_customers/chat_widget/chat_core/pkt/pb.pb.dart';
import 'package:chat_online_customers/chat_widget/chat_model/chatFaqModel.dart';
import 'package:chat_online_customers/chat_widget/chat_model/chat_faq_model.dart';
import 'package:chat_online_customers/chat_widget/chat_page/key_board_component/action.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'state.dart';
import 'action.dart';
import 'back_text.dart';
import 'chat_anwser.dart';
import 'chat_more_question.dart';
import 'chat_pic.dart';
import 'chat_question.dart';
import 'chat_sys.dart';
import 'chat_text.dart';

Widget getCurrentTypeWidget(Dispatch dispatch, ListState state,
    ViewService viewService, dynamic data, bool isUpSuccess) {
  Map<String, bool> loadingState = state.loadingState;
  PlayerInfo playerInfo = state.playerInfo ?? state.forcePlayerInfo;
  ServicerInfoFields servicerInfoFields = state.servicerInfoFields;

  // 判断加载图片是否上传成功
  //
  bool _isUpPicSuccess(String url, String time) {
    //  如果为http开头则和这上传无关
    if (url.startsWith('http')) {
      return true;
    } else {
      // 不是http开始就是两种情况一种上传成功加载本地文件，一种上传失败
      return state.images[time] == null;
    }
  }

  if ((data is ChatFields)) {
    if (data.photo.length > 0) {
      bool isUpSuccess = _isUpPicSuccess(data?.photo[0], data.time.toString());
      return isUpSuccess
          ? PicMsgWidget<ChatFields, PlayerInfo, ServicerInfoFields>(
              data, viewService, playerInfo, servicerInfoFields,
              loadingState: loadingState)
          : Container(
              child: GestureDetector(
                  onTap: () {
                    dispatch(KeyBoardActionCreator.upPicAction(
                        state.images[data.time.toString()]));
                    dispatch(ListActionCreator.onRemoveListFile(data.time));
                    dispatch(ListActionCreator.onRemovePicFile(
                        data.time.toString()));
                  },
                  child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(top: 10, right: 50),
                      child: Text('上传失败重新上传！',
                          style: TextStyle(color: Colors.blue)))));
    } else {
      return NormalTextWidget<ChatFields, PlayerInfo, ServicerInfoFields>(
          data, viewService, playerInfo, servicerInfoFields, state);
    }
  } else if (data is ServicerInfoFields) {
    return SystemContentWidget(data, viewService);
  } else if (data is ChatFaqModel) {
    return ChatFAQQuestionWidget(data, dispatch);
  } else if (data is ChatAnwserModel) {
    return ChatMoreQuestionWidget(dispatch, data);
  } else if (data is ChatResultModel) {
    return ChatAnwserWidget(data, state.customerAvatar, state.customername,
        dispatch, state, state.questBean, state.faqModel);
  } else if (data is TimeDownBean) {
    return TimeDownText(data);
  } else {
    return SystemContentWidget(data, viewService);
  }
}
