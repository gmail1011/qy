import 'package:chat_online_customers/chat_widget/chat_core/network/connection/chat_color.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_model/chat_faq_model.dart';
import 'package:flutter_svg/svg.dart';

import '../../chat_core/network/connection/connect_util.dart';

import '../../chat_model/chatFaqModel.dart';
import '../utils/bubble_style.dart';
import '../utils/tool.dart';
import 'package:bubble/bubble.dart';
import '../../chat_page/utils/bubble_style.dart';
import '../../chat_page/utils/tool.dart';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../action.dart';
import 'action.dart';
import 'state.dart';

class ChatAnwserWidget extends StatelessWidget {
  final ChatResultModel data;
  final QuestBean oldBean;
  final String avatar;
  final String name;
  final Dispatch dispatch;
  final ListState state;
  final FaqModel faqModel;
  ChatAnwserWidget(this.data, this.avatar, this.name, this.dispatch, this.state,
      this.oldBean, this.faqModel);
  @override
  Widget build(BuildContext context) {
    return myAnwserItem(context);
  }

  Widget myAnwserItem(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FaqAvatarWidget(avatar),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text('官方助手', //name ?? '客服妹子',
                            style: TextStyle(
                                fontSize: 12,
                                color: SocketManager()
                                    .model
                                    .nicknameColor) //TextStyle(fontSize: 15),
                            ),
                      ),
                      // MyAnwserBubbleWidget(data)
                      MyAnwserWidget(dispatch, data, oldBean, state, faqModel)
                    ]),
              )
            ]));
  }
}

class MyAnwserWidget extends StatelessWidget {
  final Dispatch dispatch;
  final ChatResultModel model;
  final QuestBean oldBean;
  final ListState state;
  final FaqModel faqModel;
  MyAnwserWidget(
      this.dispatch, this.model, this.oldBean, this.state, this.faqModel);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Bubble(
            style: myBubble(context, 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnswerContentWidget(dispatch, model),
              ],
            )),
        Instance.isConnect == false
            ? ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65),
                child: ResultButtonWidget(dispatch))
            : Container()
      ],
    );
  }
}

class AnswerContentWidget extends StatelessWidget {
  final Dispatch dispatch;
  final ChatResultModel model;
  AnswerContentWidget(this.dispatch, this.model);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Text(
                  model.questTitle,
                  style: TextStyle(
                      fontSize: 14, color: SocketManager().model.questionColor),
                )),
                Container(height: 6),
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   '答：' + model.questAnswer,
                        //   style: TextStyle(
                        //       fontSize: 12,
                        //       height: 1.8,
                        // color: SocketManager()
                        //     .model
                        //     .questionColor
                        //     .withOpacity(0.7)),
                        // ),
                        GestureDetector(
                          child: Text.rich(
                              TextSpan(children: richText(model.questAnswer))),
                        ),
                        model.data.length > 0
                            ? Container(
                                padding: EdgeInsets.only(top: 30),
                                child: Text('其他相关内容：',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: SocketManager()
                                            .model
                                            .baseColor) //TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                              )
                            : Container(),
                        Container(
                            padding: EdgeInsets.only(bottom: 10, top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: detailListWidget(dispatch, model.data),
                            ))
                      ]),
                ),
              ]))
    ]);
  }
}

class ResultButtonWidget extends StatelessWidget {
  final Dispatch dispatch;
  ResultButtonWidget(this.dispatch);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        // color: Colors.grey,
        child: Column(children: <Widget>[
          Container(
              padding: EdgeInsets.only(bottom: 10, top: 6),
              child: Text('您的问题是否解决',
                  style: TextStyle(
                      color: SocketManager().model.baseColor,
                      fontSize: 10)) //TextStyle(color: Colors.black)),
              ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    dispatch(ListActionCreator.onSolveQuest('已解决'));
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    width: (MediaQuery.of(context).size.width * 0.6 - 40) / 3,
                    color: SocketManager().model.faqBtnBackgroundColor,
                    child: Text('已解决',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: SocketManager().model.primaryColor)),
                  ),
                ),
                Container(width: 10),
                GestureDetector(
                  onTap: () {
                    dispatch(ListActionCreator.onOtherQuest('其他疑问'));
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    width: (MediaQuery.of(context).size.width * 0.6 - 40) / 3,
                    color: SocketManager().model.faqBtnBackgroundColor,
                    child: Text('其他疑问',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: SocketManager().model.primaryColor)),
                  ),
                ),
                Container(width: 10),
                GestureDetector(
                  onTap: () {
                    dispatch(ChatActionCreator.onConnectWebSocket('未解决'));
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    width: (MediaQuery.of(context).size.width * 0.6 - 40) / 3,
                    color: SocketManager().model.faqBtnBackgroundColor,
                    child: Text('未解决',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: SocketManager().model.primaryColor,
                            fontSize: 10)),
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}

class MyAnwserBubbleWidget extends StatelessWidget {
  final QuestBean bean;
  MyAnwserBubbleWidget(this.bean);
  @override
  Widget build(BuildContext context) {
    return Bubble(
      style: myBubble(context, 2),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            child: Container()),
        //Column(children: //titleListWidget(data))),
        Container(height: 10),
        Text(showMsgTime(DateTime.now().millisecondsSinceEpoch))
      ]), //Text('Can you help me?'),
    );
  }
}

List<WidgetSpan> richText(text) {
  List<WidgetSpan> list = List();
  var stringArr = SocketManager().getUrl(text);
  print('$stringArr');
  for (var i = 0; i < stringArr.length; i++) {
    String t = stringArr[i];
    if (t.contains('http')) {
      list.add(
        WidgetSpan(
            child: GestureDetector(
          onTap: () {
            SocketManager().launchURL(t);
          },
          child: Text(t,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                  decoration: TextDecoration.underline)),
        )),
      );
    } else {
      list.add(WidgetSpan(
          child: GestureDetector(
        child: Text(t,
            style: TextStyle(
                fontSize: 13,
                color: SocketManager().model.questionColor.withOpacity(0.7))),
      )));
    }
  }
  return list;
}
