import 'package:chat_online_customers/chat_widget/chat_core/network/connection/chat_color.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_model/chat_faq_model.dart';

import 'package:bubble/bubble.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../action.dart';
import 'tool.dart';

BubbleStyle myBubble(BuildContext context, int type) {
  double pixelRatio = MediaQuery.of(context).devicePixelRatio;
  double px = 1 / pixelRatio;
  if (type != 1) {
    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: SocketManager().model.customerBackGroundColor,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 10.0),
      alignment: Alignment.topLeft,
    );
    return styleSomebody;
  } else {
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: SocketManager()
          .model
          .userBackGroundColor, //Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 0),
      alignment: Alignment.topRight,
    );
    return styleMe;
  }
}

//头像
class AvatarWidget extends StatelessWidget {
  final String avatar;
  AvatarWidget(this.avatar);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      padding: EdgeInsets.all(10),
      child: ClipOval(
          child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[50], width: 0.5), // 边色与边宽度
          color: Color(0xFF9E9E9E), // 底色
        ),
        child: PlaceHolderImgWidget(avatar),
      )),
    );
  }
}

//头像
class FaqAvatarWidget extends StatelessWidget {
  final String avatar;
  FaqAvatarWidget(this.avatar);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      padding: EdgeInsets.all(10),
      child: ClipOval(
          child: Container(
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.grey[50], width: 0.5), // 边色与边宽度
        // color: Color(0xFF9E9E9E), // 底色
        // ),
        child: SvgPicture.asset(SocketManager().model.faqHeadImgPath),
      )),
    );
  }
}

List<Widget> detailListWidget(
    Dispatch dispatch, List<ChatAnwserDataBean> data) {
  List<Widget> list = List();
  for (var i = 0; i < data.length; i++) {
    ChatAnwserDataBean t = data[i];
    list.add(
      GestureDetector(
          onTap: () {
            List tlist = List();
            for (var i = 0; i < data.length; i++) {
              ChatAnwserDataBean b = data[i];
              Map<String, dynamic> m = Map();
              m['questTitle'] = b.questTitle;
              m['questAnswer'] = b.questAnswer;
              tlist.add(m);
            }
            ChatAnwserDataBean bean = t;
            Map<String, dynamic> map = Map();
            map['questTitle'] = bean.questTitle;
            map['questAnswer'] = bean.questAnswer;
            map['data'] = tlist;
            dispatch(ChatActionCreator.onSelectAnwser(map));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 8),
              Container(
                child: Text(t.questTitle,
                    style: TextStyle(
                        color: SocketManager().model.primaryColor,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        height:
                            1.5) //TextStyle(fontSize: 18, color: Color(0xFF0349FF)),
                    ),
              )
            ],
          )),
    );
  }

  return list;
}
