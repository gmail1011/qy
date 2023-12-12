import 'dart:async';
import 'dart:io';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/connect_util.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/msg_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_model/chat_faq_model.dart';
import 'package:chat_online_customers/chat_widget/chat_page/List_component/chat_relink.dart';
import 'package:chat_online_customers/chat_widget/chat_page/List_component/chat_voice.dart';
import 'package:chat_online_customers/chat_widget/chat_page/key_board_component/action.dart';

import '../../chat_core/pkt/pb.pb.dart';
import '../../chat_model/chatFaqModel.dart';
import '../../chat_page/utils/visible.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'action.dart';
import 'back_text.dart';
import 'chat_anwser.dart';
import 'chat_more_question.dart';
import 'chat_pic.dart';
import 'chat_question.dart';
import 'chat_sys.dart';
import 'chat_text.dart';
import 'state.dart';

Widget buildView(ListState state, Dispatch dispatch, ViewService viewService) {
  List list = state.list;
  Map<String, bool> loadingState = state.loadingState;
  PlayerInfo playerInfo = state.playerInfo ?? state.forcePlayerInfo;
  ServicerInfoFields servicerInfoFields = state.servicerInfoFields;
  Map<String, File> images = state.images;
  // ObtainRefreshController state.controller = ObtainRefreshController();

  _onRefresh() {
    if (Instance.isConnect == false) {
      dispatch(ListActionCreator.onEndRefresh(state.reverse));
    } else {
      dispatch(ListActionCreator.onChangeIsScrollToBottom(false));
      dispatch(ListActionCreator.onSendHistoryRequest());
      // dispatch(ListActionCreator.onEndRefresh(state.reverse));

    }
  }

  // 判断加载图片是否上传成功
  //
  bool _isUpPicSuccess(String url, String time) {
    //  如果为http开头则和这上传无关
    if (url.startsWith('http')) {
      return true;
    } else {
      // 不是http开始就是两种情况一种上传成功加载本地文件，一种上传失败
      return images[time] == null;
    }
  }

  if (state.isScrollToBottom)
    Timer(Duration(milliseconds: 0), () {
      state.controller.position.animateTo(
          state.reverse == false
              ? state.controller.position.maxScrollExtent
              : state.controller.position.minScrollExtent,
          duration: Duration(milliseconds: 1),
          curve: Curves.easeIn);
    });
  if (state.list.length > 1 && state.isScrollToBottom) {
    state.controller.position.animateTo(1,
        duration: Duration(milliseconds: 1), curve: Curves.easeIn);
  }

  Widget currentWidget(dynamic data) {
    if ((data is ChatFields)) {
      if (data.photo.length > 0 || data.text.length == 0 || data.text == null) {
        // var photo = data.photo[0];
        if (data.photo.length == 0 ||
            data.photo == null ||
            data.photo.first.startsWith('aac_')) {
          return ChatVoicePage(
              data, viewService, playerInfo, servicerInfoFields, dispatch);
        } else {
          bool b = _isUpPicSuccess(data.photo[0], data.time.toString());
          return b
              ? PicMsgWidget<ChatFields, PlayerInfo, ServicerInfoFields>(
                  data, viewService, playerInfo, servicerInfoFields,
                  loadingState: loadingState)
              : Container(
                  child: GestureDetector(
                      onTap: () {
                        dispatch(KeyBoardActionCreator.upPicAction(
                            images[data.time.toString()]));
                        dispatch(ListActionCreator.onRemoveListFile(data.time));
                        dispatch(ListActionCreator.onRemovePicFile(
                            data.time.toString()));
                      },
                      child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(top: 10, right: 50),
                          child: Text('上传失败重新上传！',
                              style: TextStyle(color: Colors.blue)))));
        }
      } else {
        return NormalTextWidget<ChatFields, PlayerInfo, ServicerInfoFields>(
            data, viewService, playerInfo, servicerInfoFields,state);
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
    }
    // else if (data is ServicerInfoBox) {
    //   return Container(
    //     alignment: Alignment.center,
    //     width: MediaQuery.of(viewService.context).size.width * 0.67,
    //     margin: EdgeInsets.only(left: 10, right: 10, top: 10),
    //     padding: EdgeInsets.all(10),
    //     decoration: BoxDecoration(
    //       color: Color(0x50999999),
    //       borderRadius: BorderRadius.circular(6),
    //     ),
    //     child: Text(
    //       data.servicerInfoFields.declaration,
    //       textAlign: TextAlign.center,
    //       style: TextStyle(
    //         fontSize: 12,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //   );
    // }
    else if (data is TimeDownBean) {
      return TimeDownText(data);
    } else {
      return SystemContentWidget(data, viewService);
    }
  }

  return NotificationListener<ScrollNotification>(
    onNotification: (ScrollNotification notification) {
      if (notification is ScrollEndNotification) {
        dispatch(ListActionCreator.onSendMsgIsRead(indexList));
        indexList.clear();
      }
      return;
    },
    child: Flexible(
      child: SmartRefresher(
        controller: state.controller,
        footer: CustomFooter(builder: (BuildContext context, LoadStatus mode) {
          return Container();
        }),
        enablePullDown: state.reverse == false ? true : false,
        enablePullUp: state.reverse == false ? false : true,
        onLoading: () {
          _onRefresh();
        },
        onRefresh: () {
          _onRefresh();
        },
        onOffsetChange: (a, v) {},
        child: Column(
          children: <Widget>[
            Visibility(
                visible: state.socketType == SocketStateEnum.CONNECTED,
                child: Expanded(
                    child: ListView.custom(
                  reverse: state.reverse,
                  childrenDelegate: MySliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var data = list[index];
                      return currentWidget(data);
                    },
                    childCount: list.length,
                  ),
                ))),
            Visibility(
                visible: state.socketType != SocketStateEnum.CONNECTED,
                child: ChatRelinkWidget(state, viewService, dispatch))
          ],
        ),
      ),
    ),
  );
}

class ObtainRefreshController extends RefreshController {
  factory ObtainRefreshController() => _getInstance();

  static ObtainRefreshController _instance;

  ObtainRefreshController._internal() {
    // 初始化
  }
  static ObtainRefreshController _getInstance() {
    if (_instance == null) {
      _instance = ObtainRefreshController._internal();
    }
    return _instance;
  }
}
