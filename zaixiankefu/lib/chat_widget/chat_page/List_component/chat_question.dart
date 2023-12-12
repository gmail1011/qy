import 'package:chat_online_customers/chat_widget/chat_core/network/connection/chat_color.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_model/chat_faq_model.dart';
import '../utils/bubble_style.dart';
import 'package:bubble/bubble.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../action.dart';

class ChatFAQQuestionWidget extends StatefulWidget {
  final ChatFaqModel data;
  final Dispatch dispatch;
  // final String avatar;
  ChatFAQQuestionWidget(this.data, this.dispatch);
  @override
  _ChatFAQQuestionWidgetState createState() => _ChatFAQQuestionWidgetState();
}

class _ChatFAQQuestionWidgetState extends State<ChatFAQQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return myQuestionItem(context);
  }

  Widget myQuestionItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FaqAvatarWidget(SocketManager().model.faqHeadImgPath),
          Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('官方助手',
                        style: TextStyle(
                            fontSize: 12,
                            color: SocketManager().model.nicknameColor)),
                  ),
                  // QuestionWidget(widget.data, widget.dispatch)
                  Container(
                      child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.67),
                    child: Bubble(
                        style: myBubble(context, 2),
                        child: QuestionWidget(widget.data, widget.dispatch)),
                  ))
                ]),
          )
        ],
      ),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final Dispatch dispatch;
  final ChatFaqModel groupInfo;
  QuestionWidget(this.groupInfo, this.dispatch);
  @override
  Widget build(BuildContext context) {
    List<Widget> list = List();
    for (int i = 0; i < groupInfo.data.length; i++) {
      ChatDataBean bean = groupInfo.data[i];
      list.add(Container(
        child: GestureDetector(
          onTap: () {
            dispatch(ChatActionCreator.onSelectFaqQuestionItem(bean));
          },
          child: Container(
              width: (MediaQuery.of(context).size.width * 0.6 - 36) / 2,
              height: 30,
              child: Center(
                child: Text(bean.questName,
                    style: TextStyle(
                        fontSize: 12,
                        color: SocketManager().model.primaryColor)),
              )),
        ),
      ));
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('亲爱的主人阁下，万分抱歉呢！\n客服MM有点忙哟，妹妹会尽快回复您的，么么哒！',
                style: TextStyle(fontSize: 13, color: SocketManager().model.baseColor)),
            Container(height: 8),
            Text(
              '常见问题请点击如下问题',
              style: TextStyle(
                  color: SocketManager().model.baseColor, fontSize: 12),
            ),
            Container(height: 8),
            Wrap(
                spacing: 10.0, // 主轴(水平)方向间距
                runSpacing: 10.0, // 纵轴（垂直）方向间距
                alignment: WrapAlignment.start, //沿主轴方向居中
                direction: Axis.horizontal,
                children: list)
          ]),
    );
  }
}
