import 'package:chat_online_customers/chat_widget/chat_core/network/connection/chat_color.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_model/chat_faq_model.dart';

import '../utils/bubble_style.dart';
import 'package:bubble/bubble.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class ChatMoreQuestionWidget extends StatelessWidget {
  final Dispatch dispatch;
  final ChatAnwserModel anwserModel;
  ChatMoreQuestionWidget(this.dispatch,this.anwserModel);
  @override
  Widget build(BuildContext context) {
    return moreRequestionItem(context);
  }

  Widget moreRequestionItem(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 30),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FaqAvatarWidget(SocketManager().model.faqHeadImgPath),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          '官方助手',
                          style: TextStyle(fontSize: 12,color: SocketManager().model.nicknameColor),
                        ),
                      ),
                      // MsgBubble(bean)
                      MyQuestionBubbleWidget(dispatch, anwserModel),
                    ]),
              )
            ]));
  }
}

class MyQuestionBubbleWidget extends StatelessWidget {

  final Dispatch dispatch;
  final ChatAnwserModel anwserModel;
  MyQuestionBubbleWidget( this.dispatch,this.anwserModel);
  @override
  Widget build(BuildContext context) {
    return Bubble(
      style: myBubble(context, 2),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Text('问题如下', style: TextStyle(fontSize: 14,color: SocketManager().model.baseColor))),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: detailListWidget(dispatch,anwserModel.data)),
              )
            ]),
      ),
    );
  }
}


// class MsgBubble extends StatelessWidget {
//   final QuestBean bean;
//   final QuestBean oldBean;
//   MsgBubble(this.bean,this.oldBean);

//   @override
//   Widget build(BuildContext context) {
//     return Bubble(
//         style: myBubble(context, 2),
//         child: Container(
//             child: Column(children: <Widget>[
//           Container(
//             child: Text("问题如下：",
//                 style: TextStyle(fontSize: 16, color: Colors.black)),
//           ),
//           Container(
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: questionList(bean)),
//           )
//         ])) //Text('Can you help me?'),
//         );
//   }

//   List<Widget> questionList(QuestBean bean) {
//     List<Widget> list = List();
//     for (var i = 1; i < bean.questTitle.length; i++) {
//       QuestTitleBean titleBean = bean.questTitle[i];
//       list.add(Container(
//         child: Text(
//           titleBean.name,
//           maxLines: 10,
//           style: TextStyle(fontSize: 15, color: Colors.blue),
//         ),
//       ));
//     }
//     return list;
//   }
// }
