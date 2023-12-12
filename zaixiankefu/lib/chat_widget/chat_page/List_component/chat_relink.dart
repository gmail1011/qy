import 'package:chat_online_customers/chat_widget/chat_core/network/connection/msg_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_page/List_component/state.dart';
import 'package:flutter/material.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';

class ChatRelinkWidget extends StatelessWidget {
  final ListState state;
  final ViewService viewService;
  final Dispatch dispatch;
  ChatRelinkWidget(this.state, this.viewService, this.dispatch);
  @override
  Widget build(BuildContext context) => textItem(state, viewService, dispatch);

  Widget textItem(dynamic bean, ViewService viewService, Dispatch dispatch) {
    return Container(
      width: MediaQuery.of(viewService.context).size.width * 0.67,
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 0,
            maxWidth: MediaQuery.of(viewService.context).size.width * 0.5),
        child: Center(
            child: Column(
          children: <Widget>[
            Visibility(
                visible: state.socketType == SocketStateEnum.ERROR,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("连接失败..."),
                    SizedBox(width: 20),
                    Container(
                      width: 120,
                      height: 30,
                      child: RaisedButton(
                        onPressed: () {
                          dispatch(ListActionCreator
                              .onReconnectAfterDisconnection());
                        },
                        color: Color.fromRGBO(244, 143, 145, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          "重新连接",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    )
                  ],
                )),
            Visibility(
                visible: state.socketType == SocketStateEnum.CONNECTING,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(state.pointText),
                    ],
                  ),
                ))
          ],
        )),
      ),
    );
  }
}
