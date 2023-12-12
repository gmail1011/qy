import 'package:chat_online_customers/chat_widget/chat_core/network/connection/connect_util.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_page/List_component/state.dart';

import '../utils/bubble_style.dart';
import '../utils/tool.dart';
import 'package:bubble/bubble.dart';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

//普通文本消息类型
class NormalTextWidget<T, P, V> extends StatelessWidget {
  final T bean;
  final ViewService viewService;
  final P p;
  final V value;
  final ListState state;
  NormalTextWidget(this.bean, this.viewService, this.p, this.value, this.state);
  Widget build(BuildContext context) {
    return textItem(bean, viewService, p, value, state);
  }

  Widget textItem(dynamic bean, ViewService viewService, dynamic p,
      dynamic value, ListState state) {
    Map sendMsgStatus = state.sendMsgStatus;
    return Container(
      child: Row(
          mainAxisAlignment:
              bean.type == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            bean.type != 1
                ? (AvatarWidget(Instance.customerAvatar) ??
                    AvatarWidget(value?.avatar ?? ''))
                : Container(),
            Container(
              child: Column(
                  crossAxisAlignment: bean.type == 1
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                          bean.type == 1
                              ? (SocketManager().model?.username ??
                                  p?.username ??
                                  '')
                              : value?.username ?? Instance.customerUsername,
                          style: TextStyle(
                              fontSize: 12,
                              color: SocketManager()
                                  .model
                                  .nicknameColor) //TextStyle(fontSize: 15),
                          ),
                    ),
                    Row(
                      children: [
                        Visibility(
                          visible: bean.type == 1 &&
                              sendMsgStatus[bean.messageId] == "1",
                          child: Container(
                            margin: EdgeInsets.only(left: 50.0),
                            child: createLoadingView(),
                          ),
                        ),
                        Visibility(
                          visible: bean.type == 1 &&
                              sendMsgStatus[bean.messageId] == "2",
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: new BorderRadius.circular((20.0)),
                            ),
                            child: Center(
                              child: Text(
                                "!",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                            ),
                          ),
                        ),
                        Bubble(
                          style: myBubble(viewService.context, bean.type),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(viewService.context)
                                                  .size
                                                  .width *
                                              0.6),
                                  child: Text.rich(
                                      TextSpan(children: richText(bean.text))),
                                  // child: Text(bean.text,
                                  //     style: TextStyle(
                                  //         fontSize: 12,
                                  //         color: SocketManager()
                                  //             .model
                                  //             .baseColor) //TextStyle(fontSize: 16)
                                  //     )
                                ),
                                // Container(height: 10),
                                // Container(
                                //   child: Row(
                                //     children: <Widget>[
                                //       Text(showMsgTime(bean.time),
                                //           style: TextStyle(
                                //               fontSize: 10,
                                //               color: SocketManager().model.baseColor)),
                                //       bean.type == 1
                                //           ? Container(
                                //               padding: EdgeInsets.only(left: 8),
                                //               child: Text(
                                //                   bean.isRead != 2 ? '未读' : '已读',
                                //                   style: bean.isRead != 2
                                //                       ? TextStyle(
                                //                           color:
                                //                               SocketManager().model.unReadColor,
                                //                           fontSize: 10)
                                //                       : TextStyle(
                                //                           color: SocketManager().model
                                //                               .alreadyReadColor,
                                //                           fontSize: 10)),
                                //             )
                                //           : Container()
                                //     ],
                                //   ),
                                // )
                              ]), //Text('Can you help me?'),
                        )
                      ],
                    ),
                    bean.type == 1
                        ? Container(
                            padding: EdgeInsets.only(right: 6, top: 4),
                            child: Text(bean.isRead != 2 ? '未读' : '已读',
                                style: bean.isRead != 2
                                    ? TextStyle(
                                        color:
                                            SocketManager().model.unReadColor,
                                        fontSize: 10)
                                    : TextStyle(
                                        color:
                                            SocketManager().model.primaryColor,
                                        fontSize: 10)),
                          )
                        : Container()
                  ]),
            ),
            // bean.type == 1 ? AvatarWidget(p.avatar) : Container(height: 0),
            bean.type == 1
                ? AvatarWidget(SocketManager().model?.avatar)
                : Container(height: 0),
          ]),
    );
  }
}

List<WidgetSpan> richText(text) {
  List<WidgetSpan> list = List();
  var stringArr = SocketManager().dealText(text);
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

Widget createLoadingView() {
  return Center(
    child: Container(
      width: 18.0,
      height: 18.0,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        backgroundColor: Colors.black38,
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    ),
  );
}
